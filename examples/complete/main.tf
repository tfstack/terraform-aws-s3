terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# Fetch AWS Account ID dynamically
data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

module "s3_bucket" {
  source = "../.."

  # General Configuration
  bucket_name   = "test-bucket"
  bucket_suffix = random_string.suffix.result
  force_destroy = true
  tags = {
    Environment = "dev"
    Project     = "example-project"
  }

  # Ownership and Access Controls
  object_ownership        = "BucketOwnerPreferred"
  bucket_acl              = "private"
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
  allowed_principals      = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]

  # Security & Encryption
  sse_algorithm = "AES256"

  # Versioning
  enable_versioning = true

  # Logging Configuration
  logging_enabled              = true
  logging_encryption_enabled   = true
  logging_encryption_algorithm = "AES256"
  logging_log_retention_days   = 90
  logging_s3_prefix            = "logs/"
}

# Outputs
output "all_module_outputs" {
  description = "All outputs from the S3 Bucket module"
  value       = module.s3_bucket
}
