# Local values for common naming patterns and configurations
locals {
  # Standardized naming prefix for all resources
  name_prefix = "${var.environment}-${var.project}"
  
  # Common tags applied to all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
    Module      = "aws_bootstrap"
  }
}
