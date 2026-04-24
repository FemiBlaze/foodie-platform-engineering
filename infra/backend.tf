# Backend config cannot use Terraform variables directly.
# To parameterize backend settings, initialize with -backend-config or use a separate backend config file.
terraform {
  backend "s3" {
    bucket         = "foodie-terraform-state-blaze"
    key            = "ecs/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}