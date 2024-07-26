
################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = local.vpc_name
  cidr = var.vpc_cidr

  azs = var.availability_zones

}

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
