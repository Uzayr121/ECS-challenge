resource "aws_lb" "test" {
  name               = var.alb_name 
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_alb_id]
  subnets            = [var.public_subnet_id_1, var.public_subnet_id_2]
}

# target group 
resource "aws_lb_target_group" "ECS-tg" {
  name        = var.target_group_name
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

# Listener HTTP
resource "aws_lb_listener" "http-lb" {
  load_balancer_arn = aws_lb.test.arn
    port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
   }
}
# Listener HTTPS
resource "aws_lb_listener" "https-lb" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:050451387626:certificate/1ecef7ae-5ec5-4dc3-a5bc-c981fb811466"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ECS-tg.arn
  }
}