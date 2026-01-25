#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#argument-reference
resource "aws_ecr_repository" "ecr_repos" {
  count = length(var.ecr_repository_names)
  name                 = "${local.name_prefix}-${var.ecr_repository_names[count.index]}"
  image_tag_mutability = var.ecr_image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}
