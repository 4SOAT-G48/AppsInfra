output "rds_cluster_endpoint" {
  description = "Endpoint do cluster RDS"
  value       = aws_rds_cluster.aurora.endpoint
}

output "rds_cluster_reader_endpoint" {
  description = "Endpoint de leitura do cluster RDS"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "rds_cluster_id" {
  description = "ID do cluster RDS"
  value       = aws_rds_cluster.aurora.id
}