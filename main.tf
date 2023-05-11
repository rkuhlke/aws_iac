################### Valheim Server ####################
# Comment out when not in use
module "ecs_hosted_valheim_server" {
  source           = "./valheim_server"
  environment      = "prod"
  application      = "valheim"
  project          = "server"
  instance_type    = var.valheim_server_instance_type
  key_name         = var.valheim_server_key_name
  vpc_name         = var.vpc_name
  my_cidr_blocks   = var.my_cidr_blocks
  cidr_blocks      = var.cidr_blocks
  account_id       = data.aws_caller_identity.current.id
  aws_region       = data.aws_region.current.name
  max_size         = var.valheim_server_max_size
  min_size         = var.valheim_server_min_size
  desired_capacity = var.valheim_server_desired_capacity
  bucket           = var.valheim_server_bucket
  world            = var.valheim_server_world
}

# output "template" {
#   value = module.ecs_hosted_valheim_server.template
# }
#################### Valheim Server ####################
