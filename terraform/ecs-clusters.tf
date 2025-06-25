### -------- Fargate Cluster -------- ###
resource "aws_ecs_cluster" "fargate" {
  name = "fargate-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "fargate_link" {
  cluster_name = aws_ecs_cluster.fargate.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1
  }
}