resource "aws_alb_target_group" "grocerymate-tg" {
  name = "grocerymate-tg"
  port = 5001
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    port = "5001"
    protocol = "HTTP"
    interval = 30
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.grocerymate-load-balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.grocerymate-tg.arn
  }
}


resource "aws_lb" "grocerymate-load-balancer" {
  name = "grocerymate-lb"
  internal = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [var.subnet_ids]
}