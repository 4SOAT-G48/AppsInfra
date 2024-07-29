
################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = local.vpc_name
  cidr = var.vpc_cidr

  azs = var.availability_zones

}

resource "aws_security_group" "default" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group padrao para a VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
  }
}

################################################################################
# Subnets
################################################################################

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
#  name = "${local.vpc_name}-public"
  vpc_id = module.vpc.vpc_id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.vpc_name}-${count.index}-public"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
#  name = "${local.vpc_name}-private"
  vpc_id = module.vpc.vpc_id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${local.vpc_name}-${count.index}-private"
  }
}

resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)
  vpc_id = module.vpc.vpc_id
  cidr_block = element(var.db_subnet_cidrs, count.index)
  availability_zone =var.availability_zones[count.index]
  tags = {
    Name = "${var.project_name}-${count.index}-db-subnet"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.db[*].id
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

