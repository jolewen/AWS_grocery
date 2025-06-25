### -------- Fargate Cluster -------- ###
resource "aws_ecs_cluster" "fargate" {
  name = "fargate-cluster"
}

resource "aws_ecs_capacity_provider" "fargate" {
  name = "FARGATE"
}

resource "aws_ecs_cluster_capacity_providers" "fargate_link" {
  cluster_name = aws_ecs_cluster.fargate.name
  capacity_providers = ["FARGATE"]
}