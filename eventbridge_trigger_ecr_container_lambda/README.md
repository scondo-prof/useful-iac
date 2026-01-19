# eventbridge_trigger_ecr_container_lambda

Creates infrastructure for an AWS Lambda function using a container image from ECR, with EventBridge (CloudWatch Events) integration for scheduled execution.

## File Structure

```
eventbridge_trigger_ecr_container_lambda/
├── lambda.tf      # ECR repository, Secrets Manager secret, Lambda function, permission, and IAM role
├── cloudwatch.tf  # CloudWatch Log Group and EventBridge rule/target
├── variables.tf   # Input variables
└── outputs.tf     # Output values
```

## Resources Defined

- `aws_secretsmanager_secret` - Secrets Manager secret for storing Lambda function secrets
- `aws_secretsmanager_secret_version` - Secret version containing the secret variables
- `aws_ecr_repository` - ECR repository for Lambda container images (with scan on push enabled)
- `aws_lambda_function` - Lambda function using container image from ECR
- `aws_lambda_permission` - Permission for EventBridge to invoke Lambda
- `aws_iam_role` - IAM execution role for Lambda (allows Lambda service to assume the role)
- `aws_iam_policy_document` - Policy document allowing Lambda service to assume the execution role
- `aws_cloudwatch_log_group` - Log group for Lambda function logs (30 day retention)
- `aws_cloudwatch_event_rule` - EventBridge rule with cron schedule expression
- `aws_cloudwatch_event_target` - EventBridge target linking the rule to the Lambda function

## Variables

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `environment` | `string` | The environment to deploy the resources to. This will be passed via CI Variables. | - |
| `project` | `string` | The project name. | - |
| `lambda_event_rule_cron` | `string` | The cron expression to trigger the Lambda function. | `"0 1 * * ? *"` |
| `lambda_secret_variables` | `map(string)` | The secret variables to pass to the Lambda function. | `{}` |
| `ecr_image_tag` | `string` | The tag of the ECR image to deploy. This will be passed via CI Variables. | - |
| `environment_variables` | `map(string)` | The environment variables to pass to the Lambda function. | `{}` |

## Usage

The Lambda function is configured with:
- Container image from ECR
- Environment variable `SECRET_ARN` pointing to the Secrets Manager secret ARN
- Scheduled execution via EventBridge using a cron expression
- CloudWatch Logs with 30-day retention
