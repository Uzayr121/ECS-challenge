# security group for alb
resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id #variable for VPC id
    name = var.alb_security_group_name # variable for security group name

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

# secuirty group for ECS
 resource "aws_security_group" "ecs_sg" {
    vpc_id = var.vpc_id
    name = var.ecs_security_group_name

ingress {
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # allow traffic from alb security group
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
 }