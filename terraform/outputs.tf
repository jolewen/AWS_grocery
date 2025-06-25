output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "fargate_cluster" {
  value = aws_ecs_cluster.fargate.name
}