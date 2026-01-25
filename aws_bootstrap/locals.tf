# Local values for common naming patterns and configurations
locals {
  # Standardized naming prefix for all resources
  name_prefix = "${var.project}-${var.environment}"
}
