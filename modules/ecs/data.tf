data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "vpc_public_subnets" {
  depends_on = [data.aws_vpc.selected]
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "sg" {
  
}