resource "aws_ecs_task_definition" "grocerymate_fargate" {
  family             = "grocerymate-fargate"
  requires_compatibilities = ["FARGATE"]
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.ecs_task_execution.arn
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "grocerymate"
      image = "ghcr.io/jolewen/grocery_webstore:fargate"
      portMappings = [
        {
          containerPort = 5001
          hostPort      = 5001
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/grocerymate"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "grocerymate" {
  name              = "/ecs/grocerymate"
  retention_in_days = 7
}

resource "aws_ecs_service" "grocerymate" {
  name            = "grocerymate-service"
  cluster         = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.grocerymate_fargate.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups = [aws_security_group.webstore_sg.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "ECS"
  }
}

