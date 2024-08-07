locals {
  #configuração do ambiente
  environment  = "dev"
  owners       = "fiap-4soat-g48"
  project_name = "fiap-4soat-g48-tc"
  eks_version  = "1.29"
  component    = "devops"
  env_name     = "${local.project_name}-${local.environment}"

  aws_default_tags = {
    owners      = local.owners
    component   = local.component
    created-by  = "terraform"
    environment = local.environment
    project = "TechChallenge"
  }

  # configuração da VPC
  vpc_params = {
    vpc_cidr               = "10.1.0.0/16"
    enable_nat_gateway     = true
    one_nat_gateway_per_az = true
    single_nat_gateway     = false
    enable_vpn_gateway     = false
    enable_flow_log        = false
  }

  # configuração do RDS PostgreSQL
  rds_params = {

    database = {
      name = "${local.project_name}-${local.environment}-pg-instance"
      #username = local.db_credentials_admin["username"]
      #password = local.db_credentials_admin["password"]
      #port     = 5432
    }

    storage = {
      type                  = "gp3"
      allocated             = 20
      encrypted             = true
      max_allocated_storage = 40
    }

    engine = {
      type    = "postgres"
      version = "16.1"
    }

    instance = {
      class    = "db.t3.micro"
      multi_az = false
    }

    configuration = {
      parameter_group_name = "default.postgres16"
      subnet_group_name    = module.vpc.db_subnet_group_name
      security_group_ids   = [module.vpc.security_group_id]
      deletion_protection  = false
      publicly_accessible  = true
      apply_immediately    = true
    }

    backup = {
      skip_final_snapshot = true
      retention_period    = 7
    }

    monitoring = {
      interval = 60
    }
  }

  # # configuração do RDS aurora
  # rds_aurora_params = {
  #   cluster_identifier      = "${local.project_name}-${local.environment}-pg-aurora-cluster"
  #   engine                  = "aurora-postgresql"
  #   engine_version          = "16"
  #   backup_retention_period = 7
  #   preferred_backup_window = "01:00-03:00"
  #   vpc_security_group_ids  = [module.vpc.security_group_id]
  #   db_subnet_group_name    = module.vpc.db_subnet_group_name
  #   skip_final_snapshot     = true
  #   instance_count          = 2
  #   instance_class          = "db.r5.large"
  #   publicly_accessible     = false
  # }


  apps_params = {
    pedido = {
      app_name       = "pedido"
      container_name = "pedido-app"
      container_port = 8081
      #container_image_url = "fiap4soatg48/develop-pedido-app:latest"
      #container_image_url = "" #module.ecr_pedido.ecr_repository_url
      memory           = "512"
      cpu              = "256"
      desired_capacity = 2
      # para criar o repositório no ECR colocar true
      # se já tiver criado pode colocar para false
      # quando for destruir o ambiente colocar para false para manter as imagens
      create_ecr = true
    }
  }
}