variable "alb_security_group_name" {
    description = "Name of the security group for alb"
    type = string
  
}

variable "ecs_security_group_name" {
    description = "Name of the security group for ecs"
    type = string
  
}

variable "vpc_id" {
    description = "VPC id"
    type = string
  
}