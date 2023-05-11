#variable "environment" {
#  type    = string
#  default = ""
#}

################################ VPC ################################
variable "vpc_name" {
  default = ""
  type    = string
}

#variable "availability_zone" {
#  default = ""
#  type    = string
#}

################################ VPC ################################


######################### Shift Code Scraper #########################

/* variable "shift-code-application" {
  type    = string
  default = ""
}

variable "shift-code-project" {
  type    = string
  default = ""
}

variable "secertName" {
  type    = string
  default = ""
}

variable "hash_key" {
  type    = string
  default = ""
}

variable "hash_key_type" {
  type    = string
  default = ""
} */

######################### Shift Code Scraper #########################

########################### Valheim Server ###########################

variable "valheim_application" {
  type    = string
  default = ""
}

variable "valheim_project" {
  type    = string
  default = ""
}

variable "valheim_server_instance_type" {
  type        = string
  description = "AWS EC2 instance type"
}

variable "valheim_server_key_name" {
  type        = string
  description = "name of key to log into ec2 instance"
}

variable "project" {
  default = ""
  type    = string
}

variable "my_cidr_blocks" {
  default = []
  type    = list(any)
}

variable "cidr_blocks" {
  default = []
  type    = list(any)
}

variable "aws_region" {
  default = ""
  type    = string
}

variable "valheim_server_max_size" {
  default = 0
  type    = number
}

variable "valheim_server_min_size" {
  default = 0
  type    = number
}

variable "valheim_server_desired_capacity" {
  default = 0
  type    = number
}

variable "valheim_server_bucket" {
  default = ""
  type    = string
}

variable "valheim_server_world" {
  default = ""
  type    = string
}

########################### Valheim Server ###########################

########################### Discord Runner ###########################
# variable "dr_instance_type" {

# }

# variable "dr_project" {
#   type = string
# }

# variable "dr_application" {
#   type = string
# }

# variable "dr_min_size" {
#   type = number
# }

# variable "dr_max_size" {
#   type = number
# }

# variable "dr_key_name" {

# }

########################### Discord Runner ###########################
