
data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_addrs" {
  source = "registry.terraform.io/hashicorp/subnets/cidr"

  base_cidr_block = local.vpc_params.vpc_cidr

  networks = [
    {
      name = "public-a"
      new_bits = 2
    },
    {
      name = "public-b"
      new_bits = 2
    },
    {
      name = "private-a"
      new_bits = 2
    },
    {
      name = "private-b"
      new_bits = 2
    }
  ]
  
}


################################################################################
# VPC Module
################################################################################
module "vpc" {
    source = "../../modulos/vpc"

    project_name = local.project_name
    environment = local.environment
    vpc_cidr = local.vpc_params.vpc_cidr
    availability_zones = data.aws_availability_zones.available.names
    public_subnet_cidrs = [for network in module.subnet_addrs.networks : network.cidr_block if network.name == "public-a" || network.name == "public-b"]
    private_subnet_cidrs = [for network in module.subnet_addrs.networks : network.cidr_block if network.name == "private-a" || network.name == "private-b"]
    
}

################################################################################
# ECR Module
################################################################################
module "ecr" {
    source = "../../modulos/ecr"

    project_name = local.project_name
    create_ecr = local.create_ecr
    repository_sufix_name = local.ecr_repository_name_app
}

################################################################################
# ECS Module
################################################################################
module "ecs" {
  source = "../../modulos/ecs"
  project_name = local.project_name
  environment = local.environment
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  ecs_cluster_name = "${local.project_name}-${local.environment}-cluster"
  ecs_params = local.ecs_params
}