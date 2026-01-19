#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#argument-reference
resource "aws_ecr_repository" "lambda_ecr_repository" {
  name                 = "${var.environment}-${var.project}-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission#argument-reference
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:eu-west-1:111122223333:rule/RunDaily"
  qualifier     = aws_lambda_alias.test_alias.name
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias
resource "aws_lambda_alias" "test_alias" {
  name             = "testalias"
  description      = "a sample description"
  function_name    = aws_lambda_function.test_lambda.function_name
  function_version = "$LATEST"
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#argument-reference
resource "aws_lambda_function" "test_lambda" {
  
  function_name = "${var.environment}-${var.project}-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = "${aws_ecr_repository.lambda_ecr_repository.repository_url}:${var.image_tag}"
  package_type  = "Image"
  architectures = ["x86_64"]
  timeout       = 300
  memory_size   = 1024
  environment {
    variables = var.environment_variables
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#argument-reference
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.test_lambda.arn]
    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#argument-reference
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}


