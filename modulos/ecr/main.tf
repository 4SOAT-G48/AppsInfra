
################################################################################
# ECR
################################################################################
resource "aws_ecr_repository" "app_repository" {
  count                = var.create_ecr ? 1 : 0
  name                 = local.repository_complete_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}