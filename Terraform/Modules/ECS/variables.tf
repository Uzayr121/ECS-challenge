variable "cluster_name" {
    description = "Name of the ECS cluster"
    type = string
  
}
variable "iam_role_name" {
    description = "Name of the IAM role"
    type = string
  
}
variable "service_name" {
    description = "Name of the ECS service"
    type = string
  
}
variable "image_id" {
    description = "ID of the image"
    type = string
  
}
variable "container_name" {
    description = "Name of the container"
    type = string
  
}
variable "family_name" {
    description = "Name of the family"
    type = string
  
}
variable "policy_arn" {
    description = "ARN of the policy"
    type = string
    default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
variable "secuity_group_ecs_id" {
    description = "ID of the security group for ECS"
    type = string
  
}
variable "private_subnet_id_1" {
    description = "Public subnet 1 id"
    type = string
  
}
variable "private_subnet_id_2" {
    description = "Public subnet 2 id"
    type = string
  
}
variable "target_group_arn" {
    description = "Target group ARN"
    type = string
   
}