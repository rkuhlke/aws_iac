resource "aws_launch_template" "ec2-launch-template" {
  name                   = format("%s-%s-%s-ec2-launch-template", var.application, var.environment, var.project)
  description            = "Launch template for aws ec2"
  image_id               = data.aws_ami.awslinux2.id
  instance_type          = var.instance_type
  user_data              = base64encode(data.template_file.user_data_file.rendered)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size            = 8
      volume_type            = "gp3"
      encrypted              = true
      delete_on_termination  = true
    }
  }

  tags = {
    Name        = format("%s-%s-%s-ec2-launch-template", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = format("%s-%s-%s-ec2-launch-template", var.project, var.environment, var.application)
      Builder     = "Terraform"
      Application = var.application
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  depends_on = [
    aws_security_group.ec2_sg
  ]
  name                      = format("%s-%s-%s-asg", var.project, var.environment, var.application)
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_grace_period = 200
  force_delete              = true
  default_cooldown          = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = true

  vpc_zone_identifier = [data.aws_subnet.public_subnet.id]
  suspended_processes = ["ReplaceUnhealthy"]

  launch_template {
    id = aws_launch_template.ec2-launch-template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = format("%s-%s-%s-ec2", var.project, var.environment, var.application)
    propagate_at_launch = true
  }

  tag {
    key                 = "Builder"
    value               = "Terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = var.application
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 1
    }
  }
}