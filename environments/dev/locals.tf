locals {
  #configuração do ambiente
  environment  = "dev"
  owners       = "fiap-4soat-g48"
  project_name = "fiap-4soat-g48-hacka"
  eks_version  = "1.29"
  component    = "devops"
  env_name     = "${local.project_name}-${local.environment}"

  aws_default_tags = {
    owners      = local.owners
    component   = local.component
    created-by  = "terraform"
    environment = local.environment
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

  # nome da imagem do container
  container_images = local.project_name
  ecr_repository_name_app = "app"
  create_ecr = true

  # configuração do ECR
  ecs_params = {
    container_name   = "app-hacka-api"
    container_port   = 8081
    #container_image_url = aws_ecr_repository.app_repository.repository_url
    container_image_url = module.ecr.ecr_repository_url
    memory           = "512"
    cpu              = "256"
    desired_capacity = 2
  }

  # configuração do RDS PostgreSQL
  rds_params = {
    
    database = {
      name     = "${local.project_name}-${local.environment}-pg-instance"
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
      security_group_ids  = [module.vpc.security_group_id]
      deletion_protection  = false
      publicly_accessible     = false
      apply_immediately = true
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
}