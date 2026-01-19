#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule#argument-reference
resource "aws_cloudwatch_event_rule" "lambda_event_rule" {
  name        = "${var.environment}-${var.project}-lambda-event-rule"
  description = "Capture each Lambda function invocation"

  schedule_expression = "cron(${var.lambda_event_rule_cron})"
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#argument-reference
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.environment}-${var.project}-lambda"
  retention_in_days = var.lambda_log_group_retention_in_days
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target#argument-reference
resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule = aws_cloudwatch_event_rule.lambda_event_rule.name
  arn  = aws_lambda_function.lambda_function.arn
}
