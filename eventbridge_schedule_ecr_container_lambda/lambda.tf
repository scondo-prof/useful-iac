#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret#argument-reference
resource "aws_secretsmanager_secret" "lambda_secret" {
  name = "${var.environment}-${var.project}-secret"
  recovery_window_in_days = var.lambda_secret_recovery_window_in_days
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
resource "aws_secretsmanager_secret_version" "lambda_secret" {
  secret_id     = aws_secretsmanager_secret.lambda_secret.id
  secret_string = jsonencode(var.lambda_secret_variables)
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#argument-reference
resource "aws_ecr_repository" "lambda_ecr_repository" {
  image_scanning_configuration {
    scan_on_push = true
  }
  image_tag_mutability = var.lambda_ecr_image_tag_mutability
  name                 = "${var.environment}-${var.project}-ecr-repo"
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

# IAM policy document for Lambda execution permissions - CloudWatch Logs and Secrets Manager access
data "aws_iam_policy_document" "lambda_execution_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.lambda_log_group.arn]
  }
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.lambda_secret.arn]
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#argument-reference
resource "aws_iam_role" "iam_for_lambda" {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  name               = "${var.environment}-${var.project}-lambda-role"
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy#argument-reference
resource "aws_iam_role_policy" "lambda_execution_policy" {
  name   = "${var.environment}-${var.project}-lambda-execution-policy"
  role   = aws_iam_role.iam_for_lambda.id
  policy = data.aws_iam_policy_document.lambda_execution_policy.json
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#argument-reference
resource "aws_lambda_function" "lambda_function" {

  architectures = ["x86_64"]
  environment {
    variables = merge(
      {
        "SECRET_ARN" = aws_secretsmanager_secret.lambda_secret.arn
      },
      var.environment_variables
    )
  }
  function_name                  = "${var.environment}-${var.project}-lambda"
  image_uri                      = "${aws_ecr_repository.lambda_ecr_repository.repository_url}:${var.ecr_image_tag}"
  memory_size                    = var.lambda_memory_size
  package_type                   = "Image"
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  role                           = aws_iam_role.iam_for_lambda.arn
  timeout                        = var.lambda_timeout
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission#argument-reference
resource "aws_lambda_permission" "lambda_allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
  statement_id  = "AllowExecutionFromCloudWatch"
}

