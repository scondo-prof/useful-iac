# eventbridge_trigger_ecr_container_lambda

> **Status: Work in Progress** - This module contains skeleton code with example resource configurations from the Terraform AWS provider documentation. Variables and outputs are pending implementation.

Creates infrastructure for an AWS Lambda function using a container image from ECR, with EventBridge (CloudWatch Events) integration.

## File Structure

```
eventbridge_trigger_ecr_container_lambda/
├── lambda.tf      # ECR repository, Lambda function, alias, permission, and IAM role
├── cloudwatch.tf  # CloudWatch Log Group and EventBridge rule/target examples
├── variables.tf   # Input variables (pending)
└── outputs.tf     # Output values (pending)
```

## Resources Defined

- `aws_ecr_repository` - ECR repository for Lambda container images (with scan on push enabled)
- `aws_lambda_function` - Lambda function using container image from ECR
- `aws_lambda_alias` - Lambda alias pointing to `$LATEST`
- `aws_lambda_permission` - Permission for EventBridge to invoke Lambda
- `aws_iam_role` - IAM execution role for Lambda
- `aws_iam_policy_document` - Policy allowing EventBridge to invoke Lambda
- `aws_cloudwatch_log_group` - Log group for Lambda function logs
- `aws_cloudwatch_event_rule` - EventBridge rule (example: console sign-in events)
- `aws_cloudwatch_event_target` - EventBridge target with input transformer example

## Expected Variables (to be implemented)

| Name | Description |
|------|-------------|
| `environment` | Environment name for resource naming |
| `project` | Project name for resource naming |
| `image_tag` | Container image tag to deploy |
| `environment_variables` | Environment variables for Lambda function |
