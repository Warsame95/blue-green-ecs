resource "aws_ecs_cluster" "url_shortener_cluster" {
    name = "${var.app_name}_cluster"

    configuration {
          execute_command_configuration {
            logging    = "DEFAULT"
        }
    }
}

resource "aws_ecs_task_definition" "task" {
  family = "${var.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
  execution_role_arn = var.execution_role_arn
  task_role_arn = var.task_role_arn

  container_definitions = jsonencode([
    {
      name = var.app_name
      image = "latest"
      cpu = 0
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort = 8080
          name = "${var.app_name}-80-tcp"
          protocol = "tcp"

        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = "/ecs/url-shortener-task"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_ecs_service" "name" {
  name = var.app_name
  cluster = aws_ecs_cluster.url_shortener_cluster
  task_definition = aws_ecs_task_definition.task.arn
  launch_type = "FARGATE"

  desired_count = 2

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    container_name = var.app_name
    container_port = 8080
    target_group_arn = var.target_group_arn
  }
}