########################## IAM ##########################

##################### EC2 #####################
data "aws_iam_policy_document" "iam-policy" {
  statement {
    sid = "ValheimServerSecretAccess"

    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      data.aws_secretsmanager_secret.server.arn,
      data.aws_secretsmanager_secret.world.arn,
      data.aws_secretsmanager_secret.password.arn
    ]
  }
  statement {
    sid = "ValheimServerECRAccess"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchCheckLayerAvailibility",
      "ecr:GetRepositoryPolicy"
    ]
    resources = [
      data.aws_ecr_repository.ecr_repo.arn
    ]
  }

  statement {
    sid = "S3Access"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:CreateMultiPartUpload",
      "s3:List*"
    ]
    resources = [
      data.aws_s3_bucket.selected.arn,
      "${data.aws_s3_bucket.selected.arn}/*"
    ]
  }

  statement {
    sid = "EC2Access"
    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ec2-trustrelationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

################### ECS ###################

data "aws_iam_policy_document" "ecs-trustrelationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "ecs_policy" {
  statement {
    sid = "ValheimServerSecretAccess"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets"
    ]

    resources = [
      data.aws_secretsmanager_secret.server.arn,
      data.aws_secretsmanager_secret.world.arn,
      data.aws_secretsmanager_secret.password.arn
    ]
  }

  statement {
    sid = "AllowEFSMountWrite"
    actions = [
      "elasticfilesystem:*"
    ]
    resources = [
      "*"
    ]
  }
}

################### ECS ###################

########################## IAM ##########################

####################### EC2 #######################

data "aws_ami" "awslinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}
####################### EC2 #######################

####################### VPC #######################
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-vpc", var.environment, var.vpc_name)
    ]
  }
}


data "aws_subnet" "public_subnet" {
  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-public-subnet", var.environment, var.vpc_name)
    ]
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-private-subnet", var.environment, var.vpc_name)
    ]
  }
}


####################### VPC #######################

################ Secrets Manager ##################
data "aws_secretsmanager_secret" "world" {
  name = "valheim-world-name"
}

data "aws_secretsmanager_secret" "password" {
  name = "valheim-server-password"
}

data "aws_secretsmanager_secret" "server" {
  name = "valheim-server-name"
}

################ Secrets Manager ##################
