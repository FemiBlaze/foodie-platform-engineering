provider "aws" {
  region = var.bootstrap_region
}
# S3 Bucket for Terraform State
resource "aws_s3_bucket" "tf_state" {
  bucket = var.bootstrap_bucket
}
# Enable Vesioning for the S3 Bucket
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
# Enable Server-Side Encryption for the S3 Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = var.bootstrap_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Locking"
  }
}