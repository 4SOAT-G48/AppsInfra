output "ecs_cluster_id" {
  description = "ID do cluster ECS"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_service_name" {
  description = "Nome do serviço ECS"
  value       = aws_ecs_service.ecs_service.name
}