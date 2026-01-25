output "ecr_repository_urls" {
  description = "List of ECR repository URLs. Order matches ecr_repository_names input. Used by other modules to reference container images."
  value       = aws_ecr_repository.ecr_repos[*].repository_url
}

output "ecr_repository_arns" {
  description = "List of ECR repository ARNs. Order matches ecr_repository_names input."
  value       = aws_ecr_repository.ecr_repos[*].arn
}

output "ecr_repository_names" {
  description = "List of ECR repository names. Order matches ecr_repository_names input."
  value       = aws_ecr_repository.ecr_repos[*].name
}