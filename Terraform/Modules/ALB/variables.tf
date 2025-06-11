variable "alb_name" {
    description = "Name of the ALB"
    type = string
  
}
variable "target_group_name" {
    description = "Name of the target group"
    type = string
  
}
variable "vpc_id" {
    description = "VPC id"
    type = string
  
}
variable "security_group_alb_id" {
    description = "Security group id for alb"
    type = string
  
}
variable ssl_policy {
    description = "SSL policy"
    type = string
    default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "certificate_arn" {
    description = "ARN of the certificate"
    type = string
    default = "arn:aws:acm:eu-west-1:050451387626:certificate/1ecef7ae-5ec5-4dc3-a5bc-c981fb811466"
  
}
variable public_subnet_id_1 {
    description = "Public subnet 1 id"
    type = string
  
}
variable public_subnet_id_2 {
    description = "Public subnet 2 id"
    type = string
  
}
