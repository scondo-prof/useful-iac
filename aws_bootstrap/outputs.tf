# ECR Repository Outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository. Used by other modules to reference container images."
  value       = aws_ecr_repository.main.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository."
  value       = aws_ecr_repository.main.arn
}

output "ecr_repository_name" {
  description = "The name of the ECR repository."
  value       = aws_ecr_repository.main.name
}
