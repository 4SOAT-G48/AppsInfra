resource "aws_docdb_cluster" "mongo" {
  cluster_identifier      = "${var.project_name}-${var.environment}-mongo-cluster"
  engine                  = "docdb"
  master_username         = var.database.username
  master_password         = var.database.password
  backup_retention_period = 7
  preferred_backup_window = "01:00-03:00"
  vpc_security_group_ids  = [var.vpc.security_group_id]
  db_subnet_group_name    = var.vpc.db_subnet_group_name
  tags = {
    Name = "${var.project_name}-mongo-cluster"
  }
}

resource "aws_docdb_cluster_instance" "mongo_instance" {
  identifier           = "${var.project_name}-${var.environment}-mongo-instance-${var.instance.name}"
  cluster_identifier   = aws_docdb_cluster.mongo.id
  instance_class       = var.instance.class
  engine               = aws_docdb_cluster.mongo.engine
  #engine_version       = aws_docdb_cluster.mongo.engine_version
  #publicly_accessible  = var.instance.publicly_accessible
  tags = {
    Name = "${var.project_name}-${var.environment}-mongo-instance-${var.instance.name}"
  }
}