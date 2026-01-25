variable "environment" {
  type        = string
  description = "The environment to deploy the resources to. This will be passed via CI Variables."
}

variable "project" {
  type        = string
  description = "The project name."
}

variable "lambda_secret_recovery_window_in_days" {
  type        = number
  description = "The recovery window in days for the Secrets Manager secret."
  default     = 0
}

variable "lambda_log_group_retention_in_days" {
  type        = number
  description = "The retention in days for the CloudWatch log group."
  default     = 7
}

variable "lambda_event_rule_cron" {
  type        = string
  description = "The cron expression to trigger the Lambda function."
  default     = "0 1 * * ? *"
}

variable "lambda_secret_variables" {
  type        = map(string)
  description = "The secret variables to pass to the Lambda function."
  default     = {}
}

variable "lambda_ecr_image_tag_mutability" {
  type        = string
  description = "The image tag mutability for the ECR repository."
  default     = "MUTABLE"
}

variable "ecr_image_tag" {
  type        = string
  description = "The tag of the ECR image to deploy. This will be passed via CI Variables."
}

variable "environment_variables" {
  type        = map(string)
  description = "The environment variables to pass to the Lambda function."
  default     = {}
}

variable "lambda_memory_size" {
  type        = number
  description = "The memory size for the Lambda function."
  default     = 1024
}

variable "lambda_reserved_concurrent_executions" {
  type        = number
  description = "The reserved concurrent executions for the Lambda function."
  default     = -1
}

variable "lambda_timeout" {
  type        = number
  description = "The timeout for the Lambda function."
  default     = 300
}

variable "bootstrap_s3_bucket" {
  type        = string
  description = "The S3 bucket name where the bootstrap Terraform state is stored."
}

variable "bootstrap_s3_key" {
  type        = string
  description = "The S3 key (path) where the bootstrap Terraform state is stored."
}

variable "bootstrap_aws_region" {
  type        = string
  description = "The AWS region where the bootstrap Terraform state S3 bucket is located."
}