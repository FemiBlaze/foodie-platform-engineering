resource "aws_ecs_cluster" "foodie" {
  name = var.ecs_cluster_name
}
resource "aws_ecs_task_definition" "foodie" {
  depends_on               = [aws_cloudwatch_log_group.ecs]
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = [var.ecs_launch_type]

  cpu    = var.ecs_task_cpu
  memory = var.ecs_task_memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.ecs_container_name
      image     = "PLACEHOLDER"
      essential = true

      portMappings = [
        {
          containerPort = var.ecs_container_port
        }
      ]


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs_log_group
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.awslogs_stream_prefix
        }
      }
    },

    # NEW RELIC SIDECAR 
    {
      name      = "newrelic-infra"
      image     = var.new_relic_sidecar_image
      essential = false

      environment = [
        {
          name  = "NRIA_LICENSE_KEY"
          value = var.new_relic_license_key
        },
        {
          name  = "NRIA_REGION"
          value = "EU"
        },
        {
          name  = "NRIA_DISPLAY_NAME"
          value = "foodie-ecs"
        }
      ]

      linuxParameters = {
        initProcessEnabled = true
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs_log_group
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "newrelic"
        }
      }
    }
   ])
}

resource "aws_ecs_service" "foodie" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.foodie.id
  task_definition = aws_ecs_task_definition.foodie.arn
  desired_count   = var.ecs_task_desired_count
  launch_type     = var.ecs_launch_type

  platform_version = var.ecs_platform_version

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foodie.arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }

  health_check_grace_period_seconds = 60

  depends_on = [aws_lb_listener.foodie]
}