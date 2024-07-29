output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "security_group_id" {
  description = "ID do security group padrão da VPC"
  value       = aws_security_group.default.id
}

output "db_subnet_group_name" {
  description = "Nome do grupo de subnets do banco de dados"
  value       = aws_db_subnet_group.default.name
}