resource "aws_security_group" "alb" {
  name        = var.alb_security_group_name
  description = "Allow inbound HTTP to ALB"
  vpc_id      = aws_vpc.foodie.id

  ingress {
    description = "Allow HTTP from the world"
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic from ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
  }
}

resource "aws_security_group" "ecs" {
  name        = var.ecs_security_group_name
  description = "Allow ALB to reach ECS tasks"
  vpc_id      = aws_vpc.foodie.id

  ingress {
    description     = "ALB to ECS"
    from_port       = var.ecs_container_port
    to_port         = var.ecs_container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
}
