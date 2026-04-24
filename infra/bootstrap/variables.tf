variable "bootstrap_region" {
  description = "AWS region for bootstrap resources"
  default     = "eu-west-1"
}

variable "bootstrap_bucket" {
  description = "S3 bucket name used for Terraform bootstrap state"
  default     = "foodie-terraform-state-blaze"
}

variable "bootstrap_lock_table_name" {
  description = "DynamoDB table name used for Terraform bootstrap state locking"
  default     = "terraform-locks"
}
