resource "aws_mq_broker" "rabbitmq" {
  broker_name = "${var.project_name}-${var.environment}-rabbitmq"
  engine_type = "RabbitMQ"
  engine_version = "3.13"
  host_instance_type = "mq.t3.micro"
  publicly_accessible = true
  auto_minor_version_upgrade = true
  #security_groups = var.vpc.security_group_ids
  user {
    username = var.broker.rabbitmq_username
    password = var.broker.rabbitmq_password
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-rabbitmq"
  }
}