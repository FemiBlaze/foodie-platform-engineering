resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.ecs_log_group
  retention_in_days = var.log_retention_days
}