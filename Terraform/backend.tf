terraform {

  required_version = ">= 1.0.0"
  backend "s3" {
    bucket = "backend-state-uzayr"
    key    = "Terraform/terraform.tfstate"
    region = "eu-west-1"
  }
}