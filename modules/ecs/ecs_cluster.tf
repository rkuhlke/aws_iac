resource "aws_ecs_cluster" "cluster" {
  name = format("%s-%s-%s-cluster", var.application, var.project, var.environment)

  lifecycle {
    create_before_destory = true
  }
}