# Local Values in Terraform
locals {
  # vpc name for vpc module and prefix for vpc endpoints
  vpc_name = "${var.project_name}-${var.environment}-vpc"
}