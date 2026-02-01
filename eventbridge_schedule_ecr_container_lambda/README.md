# eventbridge_schedule_ecr_container_lambda

Creates infrastructure for an AWS Lambda function using a container image from ECR, with EventBridge (CloudWatch Events) integration for scheduled execution.

## File Structure

```
eventbridge_schedule_ecr_container_lambda/
├── lambda.tf      # Secrets Manager secret, Lambda function, permission, and IAM role/policy
├── cloudwatch.tf  # CloudWatch Log Group and EventBridge rule/target
├── locals.tf      # Local values for naming (e.g., name_prefix)
├── variables.tf   # Input variables
└── outputs.tf     # Output values
```

## Resources Defined

- `aws_secretsmanager_secret` - Secrets Manager secret for storing Lambda function secrets
- `aws_secretsmanager_secret_version` - Secret version containing the secret variables
- `aws_lambda_function` - Lambda function using container image from ECR (repository URL provided via variable)
- `aws_lambda_permission` - Permission for EventBridge to invoke Lambda
- `aws_iam_role` - IAM execution role for Lambda (allows Lambda service to assume the role)
- `aws_iam_role_policy` - Inline IAM policy attached to the Lambda role for CloudWatch Logs and Secrets Manager access
- `aws_iam_policy_document` (assume_role_policy) - Policy document allowing Lambda service to assume the execution role
- `aws_iam_policy_document` (execution_policy) - Policy document granting CloudWatch Logs and Secrets Manager permissions
- `aws_cloudwatch_log_group` - Log group for Lambda function logs (configurable retention)
- `aws_cloudwatch_event_rule` - EventBridge rule with cron schedule expression
- `aws_cloudwatch_event_target` - EventBridge target linking the rule to the Lambda function

## Variables

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `environment` | `string` | The environment to deploy the resources to. This will be passed via CI Variables. | - |
| `project` | `string` | The project name. | - |
| `name_suffix` | `string` | Optional suffix for resource names. When set, names use `{project}-{name_suffix}-`; otherwise `{project}-`. | `""` |
| `lambda_secret_recovery_window_in_days` | `number` | The recovery window in days for the Secrets Manager secret. | `0` |
| `lambda_log_group_retention_in_days` | `number` | The retention in days for the CloudWatch log group. | `7` |
| `lambda_event_rule_cron` | `string` | The cron expression to trigger the Lambda function. | `"0 1 * * ? *"` |
| `lambda_secret_variables` | `map(string)` | The secret variables to pass to the Lambda function. | `{}` |
| `ecr_repository_url` | `string` | The URL of the ECR repository where the container image is stored. | - |
| `ecr_image_tag` | `string` | The tag of the ECR image to deploy. This will be passed via CI Variables. | - |
| `environment_variables` | `map(string)` | The environment variables to pass to the Lambda function. | `{}` |
| `lambda_memory_size` | `number` | The memory size for the Lambda function in MB. | `1024` |
| `lambda_reserved_concurrent_executions` | `number` | The reserved concurrent executions for the Lambda function. Use -1 for unlimited. | `-1` |
| `lambda_timeout` | `number` | The timeout for the Lambda function in seconds. | `300` |

## Outputs

| Name | Description |
|------|-------------|
| `lambda_function_name` | The name of the Lambda function |
| `lambda_function_arn` | The ARN of the Lambda function |
| `lambda_function_invoke_arn` | The ARN to be used for invoking Lambda function from API Gateway |
| `lambda_function_qualified_arn` | The qualified ARN (ARN with lambda version number) of the Lambda function |
| `lambda_function_version` | The version of the Lambda function |
| `lambda_secret_arn` | The ARN of the Secrets Manager secret |
| `lambda_secret_name` | The name of the Secrets Manager secret |
| `lambda_role_arn` | The ARN of the IAM role for the Lambda function |
| `lambda_role_name` | The name of the IAM role for the Lambda function |
| `lambda_log_group_name` | The name of the CloudWatch log group for the Lambda function |
| `lambda_log_group_arn` | The ARN of the CloudWatch log group for the Lambda function |
| `eventbridge_rule_arn` | The ARN of the EventBridge rule |
| `eventbridge_rule_name` | The name of the EventBridge rule |

## Usage

The Lambda function is configured with:
- Container image from ECR repository (URL provided via `ecr_repository_url` variable)
- Environment variable `SECRET_ARN` pointing to the Secrets Manager secret ARN
- Scheduled execution via EventBridge using a configurable cron expression
- CloudWatch Logs with configurable retention period
- IAM role with permissions for CloudWatch Logs (create log stream, put log events; log group is pre-created) and Secrets Manager (get secret value)
- Configurable memory size, timeout, and reserved concurrent executions

**Note:** The ECR repository must be created separately (e.g., via the `aws_bootstrap` module or manually). The repository URL is passed directly to this module via the `ecr_repository_url` variable, providing flexibility in how the repository is managed.
