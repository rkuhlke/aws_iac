resource "aws_ecs_cluster" "ecs-cluster" {
  name               = local.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.capacity-provider.name]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_ecs_capacity_provider" "capacity-provider" {
  name = format("%s-%s-%s-asg", var.project, var.environment, var.application)
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  depends_on = [
    aws_ecr_repository.ecr_repo
    # aws_iam_role.ecs_task_execution_role
  ]
  family             = format("%s-%s-%s-task", var.project, var.environment, var.application)
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  # execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  volume {
    name      = "hostVolume"
    host_path = "/home/ec2-user/worlds"
  }
  container_definitions = jsonencode([
    {
      name         = "${var.application}"
      image        = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
      cpu          = 1024
      memory       = 3072
      essential    = true
      network_mode = "host"
      mountPoints = [
        {
          "containerPath" : "/home/valheim/worlds",
          "sourceVolume" : "hostVolume"
        }
      ]

      "portMappings" = [
        {
          containerPort = 2456
          hostPort      = 2456
          protocol      = "udp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.ecs-log-group.name}"
          "awslogs-region" : "${var.aws_region}"
          "awslogs-stream-prefix" : "/ecs/${var.application}"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs-service" {
  name            = format("%s-%s-%s-ecs-service", var.project, var.environment, var.application)
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
}

resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name = format("%s-%s-%s-ecs-log-group", var.project, var.environment, var.application)
}


