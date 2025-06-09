resource "aws_ecs_cluster" "cluster" {
    name = var.cluster_name
}
# Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the ECS Task Execution policy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.policy_arn
}
resource "aws_ecs_task_definition" "ecs-td" {
    family = var.family_name
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
     cpu                      = "1024"  # 1 vCPU = 1024 CPU units
  memory                   = "3072"  # 3GB = 3072 MB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
   container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_id
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ] 
}
   ])
}

resource "aws_ecs_service" "ecs-service" {
    name = var.service_name
    cluster = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.ecs-td.arn
    desired_count = 2
    launch_type = "FARGATE"
    network_configuration {
        subnets = [var.private_subnet_id_1, var.private_subnet_id_2]
        security_groups = [var.secuity_group_ecs_id]
        assign_public_ip = true
    }
    load_balancer {
        target_group_arn = var.target_group_arn 
        container_name = var.container_name
        container_port = 3000
    }
}