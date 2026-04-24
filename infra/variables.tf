variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name used in resource tags and generated names"
  default     = "foodie-platform-engineering"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  default     = "default"
}

variable "environment" {
  description = "Environment name"
  default     = "dev"
}

variable "github_oidc_provider_url" {
  description = "OIDC provider URL for GitHub Actions"
  default     = "https://token.actions.githubusercontent.com"
}

variable "github_oidc_client_id" {
  description = "OIDC client ID list for GitHub Actions"
  default     = "sts.amazonaws.com"
}

variable "github_oidc_thumbprint" {
  description = "OIDC provider thumbprint for GitHub Actions"
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "github_oidc_role_name" {
  description = "IAM role name for GitHub Actions OIDC"
  default     = "github-actions-oidc-role"
}

variable "github_oidc_policy_name" {
  description = "IAM policy name for GitHub Actions OIDC"
  default     = "github-actions-policy"
}

variable "github_repo_owner" {
  description = "GitHub repository owner used in OIDC subject condition"
  default     = "FemiBlaze"
}

variable "github_repo_name" {
  description = "GitHub repository name used in OIDC subject condition"
  default     = "foodie-platform-engineering"
}

variable "github_repo_branch" {
  description = "GitHub branch used in OIDC subject condition"
  default     = "main"
}

variable "state_bucket_name" {
  description = "S3 bucket name used for Terraform state"
  default     = "foodie-terraform-state-blaze"
}

variable "state_key" {
  description = "S3 key used for Terraform state"
  default     = "ecs/terraform.tfstate"
}

variable "state_lock_table" {
  description = "DynamoDB table name used for Terraform state locking"
  default     = "terraform-locks"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  default     = "foodie-app"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = "foodie-cluster"
}

variable "ecs_service_name" {
  description = "ECS service name"
  default     = "foodie-service"
}

variable "ecs_task_family" {
  description = "ECS task family name"
  default     = "foodie-task"
}

variable "ecs_container_name" {
  description = "Name of the ECS container"
  default     = "foodie-container"
}

variable "ecs_image_tag" {
  description = "Tag for the ECS container image (fallback - pipeline uses dynamic versioning)"
  default     = "v1"
}

variable "pipeline_docker_image_name" {
  description = "Docker image name used by the CI/CD pipeline"
  default     = "foodie-app"
}

variable "pipeline_smoke_test_url" {
  description = "URL used by the smoke test step in the pipeline"
  default     = ""
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task"
  default     = "1024"
}

variable "ecs_task_memory" {
  description = "Memory for the ECS task"
  default     = "2048"
}

variable "ecs_task_desired_count" {
  description = "Desired count for the ECS service"
  type        = number
  default     = 2
}

variable "ecs_platform_version" {
  description = "ECS platform version"
  default     = "LATEST"
}

variable "ecs_launch_type" {
  description = "ECS launch type"
  default     = "FARGATE"
}

variable "new_relic_sidecar_image" {
  description = "New Relic sidecar image"
  default     = "newrelic/infrastructure:3.2"
}

variable "awslogs_stream_prefix" {
  description = "AWS logs stream prefix for ECS"
  default     = "ecs"
}

variable "alb_listener_port" {
  description = "ALB listener port"
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "ALB listener protocol"
  default     = "HTTP"
}

variable "alb_target_group_protocol" {
  description = "ALB target group protocol"
  default     = "HTTP"
}

variable "alb_health_check_path" {
  description = "ALB health check path"
  default     = "/"
}

variable "alb_health_check_matcher" {
  description = "ALB health check matcher"
  default     = "200"
}

variable "alb_health_check_interval" {
  description = "ALB health check interval in seconds"
  type        = number
  default     = 30
}

variable "alb_health_check_timeout" {
  description = "ALB health check timeout in seconds"
  type        = number
  default     = 5
}

variable "alb_health_check_healthy_threshold" {
  description = "ALB health check healthy threshold"
  type        = number
  default     = 2
}

variable "alb_health_check_unhealthy_threshold" {
  description = "ALB health check unhealthy threshold"
  type        = number
  default     = 2
}

variable "alb_security_group_name" {
  description = "ALB security group name"
  default     = "alb-sg"
}

variable "ecs_security_group_name" {
  description = "ECS security group name"
  default     = "ecs-sg"
}

variable "ecr_image_tag_mutability" {
  description = "ECR image tag mutability"
  default     = "MUTABLE"
}

variable "ecr_lifecycle_image_count" {
  description = "Number of images to retain in ECR"
  type        = number
  default     = 10
}

variable "application_url_scheme" {
  description = "Scheme used by the application URL output"
  default     = "http"
}

variable "ecs_container_port" {
  description = "Port exposed by the ECS container"
  type        = number
  default     = 8080
}

variable "ecs_log_group" {
  description = "CloudWatch Logs group for ECS"
  default     = "/ecs/foodie"
}

variable "alb_name" {
  description = "Application Load Balancer name"
  default     = "foodie-alb"
}

variable "alb_target_group_name" {
  description = "Target group name for the ALB"
  default     = "foodie-tg"
}

variable "iam_task_execution_role_name" {
  description = "Name for the ECS task execution IAM role"
  default     = "foodie-ecs-task-execution-role"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_route_cidr" {
  description = "CIDR block used for the public route"
  default     = "0.0.0.0/0"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed by the public security groups"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "new_relic_license_key" {
  description = "New Relic License Key"
  type        = string
  sensitive   = true
}

variable "new_relic_app_name" {
  default = "foodie-app"
}
