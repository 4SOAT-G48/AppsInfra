
data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_addrs" {
  source = "registry.terraform.io/hashicorp/subnets/cidr"

  base_cidr_block = local.vpc_params.vpc_cidr

  networks = [
    {
      name     = "public-a"
      new_bits = 4
    },
    {
      name     = "public-b"
      new_bits = 4
    },
    {
      name     = "private-a"
      new_bits = 4
    },
    {
      name     = "private-b"
      new_bits = 4
    },
    {
      name     = "db-a"
      new_bits = 8
    },
    {
      name     = "db-b"
      new_bits = 8
    }
  ]

}


################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "../../../modulos/vpc"

  project_name         = local.project_name
  environment          = local.environment
  vpc_cidr             = local.vpc_params.vpc_cidr
  availability_zones   = data.aws_availability_zones.available.names
  public_subnet_cidrs  = [for network in module.subnet_addrs.networks : network.cidr_block if network.name == "public-a" || network.name == "public-b"]
  private_subnet_cidrs = [for network in module.subnet_addrs.networks : network.cidr_block if network.name == "private-a" || network.name == "private-b"]
  db_subnet_cidrs      = [for network in module.subnet_addrs.networks : network.cidr_block if network.name == "db-a" || network.name == "db-b"]
  local_machine_ip     = var.rds_params.local_machine_ip
}

################################################################################
# ECR Module
################################################################################
module "ecr_pedido" {
  source = "../../../modulos/ecr"

  project_name          = local.project_name
  create_ecr            = local.apps_params.pedido.create_ecr
  repository_sufix_name = local.apps_params.pedido.app_name
}

module "ecr_pagamento" {
  source = "../../../modulos/ecr"

  project_name          = local.project_name
  create_ecr            = local.apps_params.pagamento.create_ecr
  repository_sufix_name = local.apps_params.pagamento.app_name
}

module "ecr_producao" {
  source = "../../../modulos/ecr"

  project_name          = local.project_name
  create_ecr            = local.apps_params.producao.create_ecr
  repository_sufix_name = local.apps_params.producao.app_name
}

module "ecr_orquestracao" {
  source = "../../../modulos/ecr"

  project_name          = local.project_name
  create_ecr            = local.apps_params.orquestracao.create_ecr
  repository_sufix_name = local.apps_params.orquestracao.app_name
}

################################################################################
# ECS Module
################################################################################
module "ecs_pedido" {
  source                  = "../../../modulos/ecs"
  region                  = var.region
  account_id              = var.aws_account_id
  project_name            = local.project_name
  environment             = local.environment
  vpc_id                  = module.vpc.vpc_id
  security_groups         = [module.vpc.security_group_id]
  subnet_ids              = module.vpc.public_subnet_ids
  ecs_cluster_name        = "${local.project_name}-${local.environment}-cluster"
  container_image_url     = module.ecr_pedido.ecr_repository_url
  ecs_params              = local.apps_params.pedido
  ecr_repository_name_app = module.ecr_pedido.ecr_repository_name
}

module "ecs_pagamento" {
  source                  = "../../../modulos/ecs"
  region                  = var.region
  account_id              = var.aws_account_id
  project_name            = local.project_name
  environment             = local.environment
  vpc_id                  = module.vpc.vpc_id
  security_groups         = [module.vpc.security_group_id]
  subnet_ids              = module.vpc.public_subnet_ids
  ecs_cluster_name        = "${local.project_name}-${local.environment}-cluster"
  container_image_url     = module.ecr_pagamento.ecr_repository_url
  ecs_params              = local.apps_params.pagamento
  ecr_repository_name_app = module.ecr_pagamento.ecr_repository_name
}

module "ecs_producao" {
  source                  = "../../../modulos/ecs"
  region                  = var.region
  account_id              = var.aws_account_id
  project_name            = local.project_name
  environment             = local.environment
  vpc_id                  = module.vpc.vpc_id
  security_groups         = [module.vpc.security_group_id]
  subnet_ids              = module.vpc.public_subnet_ids
  ecs_cluster_name        = "${local.project_name}-${local.environment}-cluster"
  container_image_url     = module.ecr_producao.ecr_repository_url
  ecs_params              = local.apps_params.producao
  ecr_repository_name_app = module.ecr_producao.ecr_repository_name
}

module "ecs_orquestracao" {
  source                  = "../../../modulos/ecs"
  region                  = var.region
  account_id              = var.aws_account_id
  project_name            = local.project_name
  environment             = local.environment
  vpc_id                  = module.vpc.vpc_id
  security_groups         = [module.vpc.security_group_id]
  subnet_ids              = module.vpc.public_subnet_ids
  ecs_cluster_name        = "${local.project_name}-${local.environment}-cluster"
  container_image_url     = module.ecr_orquestracao.ecr_repository_url
  ecs_params              = local.apps_params.orquestracao
  ecr_repository_name_app = module.ecr_orquestracao.ecr_repository_name
}

################################################################################
# RDS Module
################################################################################
module "rds" {
  source = "../../../modulos/rds"

  identifier             = local.rds_params.database.name
  engine                 = local.rds_params.engine.type
  engine_version         = local.rds_params.engine.version
  master_username        = var.rds_params.master_username
  master_password        = var.rds_params.master_password
  database_name          = var.rds_params.database_name
  vpc_security_group_ids = local.rds_params.configuration.security_group_ids
  db_subnet_group_name   = local.rds_params.configuration.subnet_group_name
  skip_final_snapshot    = local.rds_params.backup.skip_final_snapshot
  instance_class         = local.rds_params.instance.class
  publicly_accessible    = local.rds_params.configuration.publicly_accessible
  environment            = local.environment
  local_machine_ip       = var.rds_params.local_machine_ip

  storage = {
    type                  = local.rds_params.storage.type
    allocated             = local.rds_params.storage.allocated
    encrypted             = local.rds_params.storage.encrypted
    max_allocated_storage = local.rds_params.storage.max_allocated_storage
  }

  apply_immediately = local.rds_params.configuration.apply_immediately
}


################################################################################
# DocDB Module
################################################################################
module "docdb" {
  source = "../../../modulos/mongo"

  project_name = local.project_name
  environment  = local.environment
  vpc          = local.mongo_params.vpc
  database     = local.mongo_params.database
  instance     = local.mongo_params.instance
}