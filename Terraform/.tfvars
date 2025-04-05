vpc_id = aws_vpc.main.id
public_subnet_id_1 = aws_subnet.public_1.id
public_subnet_id_2 = aws_subnet.public_2.id
target_group_arn = aws_lb_target_group.ECS-tg.arn
security_group_alb_id = aws_security_group.alb_sg.id
security_group_ecs_id = aws_security_group.ecs_sg.id
image_id = "050451387626.dkr.ecr.eu-west-1.amazonaws.com/ecs-image:latest"
