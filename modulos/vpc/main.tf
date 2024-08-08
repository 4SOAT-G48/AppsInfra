
################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = local.vpc_name
  cidr = var.vpc_cidr

  azs = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  create_database_subnet_group           = var.create_database_subnet_group
  create_database_subnet_route_table     = var.create_database_subnet_route_table
  create_database_internet_gateway_route = var.create_database_internet_gateway_route

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
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

resource "aws_security_group_rule" "allow_postgres" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.default.id
  cidr_blocks       = [var.local_machine_ip]  # Use a variável local_machine_ip
}

resource "aws_security_group_rule" "allow_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.default.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}