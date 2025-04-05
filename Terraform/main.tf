module "vpc" {
  source           = "./Modules/VPC"
  vpc_name         = "main"
  internet_gway    = "igw-ecs"
  route_table_name = "main"
  subnet_name_1    = "public_1"
  subnet_name_2    = "public_2"
}

module "security-group" {
  source                  = "./Modules/Security-Group"
  vpc_id                  = module.vpc.vpc_id
  alb_security_group_name = "alb-sg"
  ecs_security_group_name = "ecs-sg"
}

module "ecs" {
  source               = "./Modules/ECS"
  cluster_name         = "ecs-cluster"
  service_name         = "ecs-service"
  public_subnet_id_1   = module.vpc.public_subnet_id_1
  public_subnet_id_2   = module.vpc.public_subnet_id_2
  family_name          = "ecs-family"
  container_name       = "ECR-repo"
  iam_role_name        = "ecs-iam-role"
  secuity_group_ecs_id = module.security-group.security_group_ecs_id
  target_group_arn     = module.ALB.target_group_arn
  image_id             = "050451387626.dkr.ecr.eu-west-1.amazonaws.com/ecs-image:latest"
}

module "ALB" {
  source                = "./Modules/ALB"
  alb_name              = "ecs-alb"
  target_group_name     = "ecs-tg"
  vpc_id                = module.vpc.vpc_id
  security_group_alb_id = module.security-group.security_group_alb_id
  public_subnet_id_1    = module.vpc.public_subnet_id_1
  public_subnet_id_2    = module.vpc.public_subnet_id_2

}