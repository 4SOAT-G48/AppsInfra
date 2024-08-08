# autputs para resource "aws_docdb_cluster" "mongo"
output "docdb_cluster_endpoint" {
  value = aws_docdb_cluster.mongo.endpoint
}

output "docdb_cluster_port" {
  value = aws_docdb_cluster.mongo.port
}

output "docdb_cluster_id" {
  value = aws_docdb_cluster.mongo.id
}

output "docdb_cluster_instance_id" {
  value = aws_docdb_cluster_instance.mongo_instance.id
}

output "docdb_cluster_instance_endpoint" {
  value = aws_docdb_cluster_instance.mongo_instance.endpoint
}

output "docdb_cluster_instance_port" {
  value = aws_docdb_cluster_instance.mongo_instance.port
}
