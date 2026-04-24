output "ecr_repo_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.foodie.repository_url
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.foodie.dns_name
}

output "alb_url" {
  description = "Full application URL"
  value       = format("%s://%s", var.application_url_scheme, aws_lb.foodie.dns_name)
}

output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.foodie.name
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.foodie.name
}

output "task_definition_family" {
  description = "ECS Task Definition Family"
  value       = aws_ecs_task_definition.foodie.family
}

output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}