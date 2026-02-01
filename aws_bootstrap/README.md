# aws_bootstrap

A Terraform module for bootstrapping AWS environments with foundational infrastructure resources that are shared across multiple applications and services. This module creates pre-requisite resources that other modules depend on, enabling centralized management of common infrastructure components.

## Purpose

The bootstrap module serves as the foundation layer for environment setup, creating resources that are:
- **Shared across multiple services**: Resources like ECR repositories that are used by multiple Lambda functions or containerized applications
- **Long-lived and stable**: Infrastructure that doesn't change frequently and benefits from centralized management
- **Pre-requisites for other modules**: Resources that other Terraform modules reference via remote state

## File Structure

```
aws_bootstrap/
├── variables.tf # Input variable declarations
├── outputs.tf   # Output value declarations (exposed to other modules via remote state)
├── locals.tf    # Local values for common naming patterns and configurations
├── ecr.tf       # ECR repository resources
└── README.md    # This file
```

## Current Resources

### ECR Repositories

The module creates multiple ECR repositories based on the `ecr_repository_names` variable. These repositories are configured with:
- Image scanning on push enabled for security
- AES256 encryption at rest
- Configurable image tag mutability (MUTABLE or IMMUTABLE)
- Standardized naming convention: `{project}-bootstrap-{repository_name}`

## Module Structure

The module follows a resource-type organization pattern:
- **Resource-specific files** (e.g., `ecr.tf`): Contains all resources of a specific type, making it easy to find and manage related infrastructure
- **Common configuration** (`locals.tf`): Centralizes naming conventions and shared values
- **Interface** (`variables.tf`, `outputs.tf`): Defines the module's inputs and outputs

This structure allows for easy extension as new resource types are added to the bootstrap module. Simply create a new `.tf` file for the resource type (e.g., `s3.tf` for S3 buckets, `vpc.tf` for VPC resources).

## Usage

This module is typically deployed first in an environment setup process. Other modules reference its outputs via `terraform_remote_state` data sources.

### Example: Consuming Bootstrap Outputs

```hcl
data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-bucket"
    key    = "bootstrap/environment.tfstate"
    region = "us-east-1"
  }
}

# Use ECR repository URL from bootstrap (outputs are lists, access by index)
resource "aws_lambda_function" "example" {
  image_uri = "${data.terraform_remote_state.bootstrap.outputs.ecr_repository_urls[0]}:latest"
  # ... other configuration
}

# Or iterate over multiple repositories
resource "aws_lambda_function" "example_multiple" {
  for_each = toset(data.terraform_remote_state.bootstrap.outputs.ecr_repository_urls)
  image_uri = "${each.value}:latest"
  # ... other configuration
}
```

## Variables

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `environment` | `string` | The environment name (e.g., dev, staging, prod) | - |
| `project` | `string` | The project name | - |
| `ecr_image_tag_mutability` | `string` | Image tag mutability for ECR repository (MUTABLE or IMMUTABLE) | `"MUTABLE"` |
| `ecr_repository_names` | `list(string)` | List of ECR repository names to create. Each name will be prefixed with '{project}-bootstrap-' | `[]` |

## Outputs

| Name | Type | Description |
|------|------|-------------|
| `ecr_repository_urls` | `list(string)` | List of ECR repository URLs (used by other modules to reference container images). Order matches `ecr_repository_names` input. |
| `ecr_repository_arns` | `list(string)` | List of ECR repository ARNs. Order matches `ecr_repository_names` input. |
| `ecr_repository_names` | `list(string)` | List of ECR repository names. Order matches `ecr_repository_names` input. |

## Future Enhancements

As infrastructure needs grow, this module can be extended to include:
- S3 buckets for application data and artifacts
- VPC and networking resources
- IAM roles and policies for shared services
- Route53 hosted zones
- Other foundational AWS resources
