data "aws_ecr_repository" "ecr_repo" {
  name                 = format("%s-%s-%s-ecr-repo", var.application, var.environment, var.project)

  tags = {
    Name        = format("%s-%s-%s-ecr-repo", var.application, var.environment, var.project)
    Builder     = "Terraform"
    Application = var.application
    environment = var.environment
  }
}