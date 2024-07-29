output "rds_instance_endpoint" {
  description = "Endpoint da instância RDS"
  value       = aws_db_instance.database.endpoint
}
output "rds_instance_id" {
  description = "ID da instância RDS"
  value       = aws_db_instance.database.id
}