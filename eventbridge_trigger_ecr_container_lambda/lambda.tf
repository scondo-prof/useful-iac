#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret#argument-reference
resource "aws_secretsmanager_secret" "lambda_secret" {
  name = "${var.environment}-${var.project}-secret"
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
resource "aws_secretsmanager_secret_version" "lambda_secret" {
  secret_id     = aws_secretsmanager_secret.lambda_secret.id
  secret_string = jsonencode(var.lambda_secret_variables)
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#argument-reference
resource "aws_ecr_repository" "lambda_ecr_repository" {
  name                 = "${var.environment}-${var.project}-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#argument-reference
# IAM policy document for Lambda execution role - allows Lambda service to assume this role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#argument-reference
resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.environment}-${var.project}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#argument-reference
resource "aws_lambda_function" "lambda_function" {
  
  function_name = "${var.environment}-${var.project}-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  image_uri     = "${aws_ecr_repository.lambda_ecr_repository.repository_url}:${var.ecr_image_tag}"
  package_type  = "Image"
  architectures = ["x86_64"]
  timeout       = 300
  memory_size   = 1024
  environment {
    variables = merge(
      {
        "SECRET_ARN" = aws_secretsmanager_secret.lambda_secret.arn
      },
      var.environment_variables
    )
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission#argument-reference
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
}

