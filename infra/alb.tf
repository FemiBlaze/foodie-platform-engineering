resource "aws_lb" "foodie" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "foodie" {
  name_prefix = "fd-"
  port        = var.ecs_container_port
  protocol    = var.alb_target_group_protocol
  vpc_id      = aws_vpc.foodie.id
  target_type = "ip"

  health_check {
    path                = var.alb_health_check_path
    protocol            = var.alb_target_group_protocol
    matcher             = var.alb_health_check_matcher
    interval            = var.alb_health_check_interval
    timeout             = var.alb_health_check_timeout
    healthy_threshold   = var.alb_health_check_healthy_threshold
    unhealthy_threshold = var.alb_health_check_unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "foodie" {
  load_balancer_arn = aws_lb.foodie.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.foodie.arn
  }
}