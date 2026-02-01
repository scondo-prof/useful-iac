# Useful IaC

A repository dedicated to reusable, remotely-referenced Terraform modules. These modules are designed to be consumed by other repositories via Git-based module sourcing, enabling consistent infrastructure patterns across projects.

## Repository Structure

```
module_name/
├── *.tf           # Resource definitions (organized by resource type)
├── variables.tf   # Input variable declarations
└── outputs.tf     # Output value declarations
```

## Available Modules

### aws_bootstrap

Creates foundational AWS infrastructure shared across applications (e.g., ECR repositories). Typically deployed first; other modules reference its outputs via remote state.

**Current version:** `bootstrap-v1.0.0`

See [aws_bootstrap/README.md](aws_bootstrap/README.md) for detailed documentation.

### eventbridge_schedule_ecr_container_lambda

Creates an AWS Lambda function using a container image from ECR, with EventBridge schedule trigger and Secrets Manager integration.

**Current version:** `event-container-lambda-v1.0.0`

See [eventbridge_schedule_ecr_container_lambda/README.md](eventbridge_schedule_ecr_container_lambda/README.md) for detailed documentation.

### All versions

| Module | Tag |
|--------|-----|
| aws_bootstrap | `bootstrap-v1.0.0` |
| eventbridge_schedule_ecr_container_lambda | `event-container-lambda-v1.0.0` |

Use the tag in the `ref` parameter when sourcing a module, e.g. `?ref=bootstrap-v1.0.0` or `?ref=event-container-lambda-v1.0.0`.

## Example: Remote Repository Setup

The `example_remote_repo_setup/` directory demonstrates best practices for consuming these modules in your own repositories:

- **S3 Backend Configuration**: Remote state storage with environment-specific state files
- **Default Tags**: Consistent resource tagging across all AWS resources
- **Environment Separation**: Using tfvars files for environment-specific configurations

### Directory Structure

```
example_remote_repo_setup/
├── config/
│   ├── test.tfvars          # Environment-specific variables
│   └── test-backend.tfvars  # Backend configuration
├── main.tf                   # Provider and backend setup
├── variables.tf              # Variable declarations
└── outputs.tf                # Output declarations
```

### Usage

```bash
# Initialize with backend configuration
terraform init -backend-config=config/test-backend.tfvars

# Plan with environment variables
terraform plan -var-file=config/test.tfvars -var="environment=test" -var="owner=your-name"

# Apply
terraform apply -var-file=config/test.tfvars -var="environment=test" -var="owner=your-name"
```

## Consuming Modules

Reference modules directly from this repository in your Terraform configurations:

```hcl
module "example" {
  source = "git::https://github.com/your-org/useful-iac.git//module_name?ref=v1.0.0"
  
  # Module variables...
}
```

**Best Practices:**
- Always pin to a specific Git ref (tag or commit SHA) for production use
- Use semantic versioning tags for stable releases
- Review module changes before updating refs in consuming repositories
