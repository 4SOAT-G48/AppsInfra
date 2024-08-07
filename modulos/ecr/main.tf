
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

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids   = var.subnet_ids
  security_group_ids = [var.security_group_id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  subnet_ids   = var.subnet_ids
  security_group_ids = [var.security_group_id]
}