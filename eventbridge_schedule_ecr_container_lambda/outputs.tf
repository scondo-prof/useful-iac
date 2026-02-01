# Lambda Function Outputs
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda_function.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_function_invoke_arn" {
  description = "The ARN to be used for invoking Lambda function from API Gateway"
  value       = aws_lambda_function.lambda_function.invoke_arn
}

output "lambda_function_qualified_arn" {
  description = "The qualified ARN (ARN with lambda version number) of the Lambda function"
  value       = aws_lambda_function.lambda_function.qualified_arn
}

output "lambda_function_version" {
  description = "The version of the Lambda function"
  value       = aws_lambda_function.lambda_function.version
}

# Secrets Manager Outputs
output "lambda_secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.lambda_secret.arn
}

output "lambda_secret_name" {
  description = "The name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.lambda_secret.name
}

# IAM Role Outputs
output "lambda_role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  value       = aws_iam_role.iam_for_lambda.arn
}

output "lambda_role_name" {
  description = "The name of the IAM role for the Lambda function"
  value       = aws_iam_role.iam_for_lambda.name
}

# CloudWatch Log Group Outputs
output "lambda_log_group_name" {
  description = "The name of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}

output "lambda_log_group_arn" {
  description = "The ARN of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.arn
}

# EventBridge Rule Outputs
output "eventbridge_rule_arn" {
  description = "The ARN of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.lambda_event_rule.arn
}

output "eventbridge_rule_name" {
  description = "The name of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.lambda_event_rule.name
}
