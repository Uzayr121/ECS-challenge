variable "vpc_name" {
    description = "Name of the VPC"
    type = string
    
}
variable "subnet_name_1" {
    description = "Name of the subnet 1"
    type = string
    
}
variable "subnet_name_2" {
    description = "Name of the subnet 2"
    type = string
}
# Compare this snippet from Terraform/Modules/ALB/main.tf:
variable "internet_gway" {
    description = "Name of the internet gateway"
    type = string
   
  
}
variable "route_table_name" {
    description = "Name of the route table"
    type = string
  
}