resource "aws_db_instance" "database" {
  identifier           = var.identifier
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.master_username
  password             = var.master_password
  db_name              = var.database_name
  
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = var.db_subnet_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  publicly_accessible  = var.publicly_accessible
  
  storage_type         = var.storage.type
  allocated_storage    = var.storage.allocated

  apply_immediately    = var.apply_immediately

  tags = {
	  Name        = var.identifier
	  Environment = var.environment
  }
}