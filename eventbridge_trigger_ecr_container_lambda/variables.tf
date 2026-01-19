variable "environment" {
  type        = string
  description = "The environment to deploy the resources to. This will be passed via CI Variables."
}

variable "project" {
  type        = string
  description = "The project name."
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

variable "ecr_image_tag" {
  type        = string
  description = "The tag of the ECR image to deploy. This will be passed via CI Variables."
}

variable "environment_variables" {
  type        = map(string)
  description = "The environment variables to pass to the Lambda function."
  default     = {}
}