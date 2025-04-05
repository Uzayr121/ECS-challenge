resource "aws_lb" "test" {
  name               = "alb-test"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# target group 
resource "aws_lb_target_group" "ECS-tg" {
  name        = "ECS-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
}

# Listener HTTP
resource "aws_lb_listener" "http-lb" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ECS-tg.arn
  }
}