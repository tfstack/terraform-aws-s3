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

# Generate a random suffix for bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

module "s3_bucket" {
  source = "../.."

  # General Configuration
  bucket_name   = "lifecycle-demo-bucket"
  bucket_suffix = random_string.suffix.result
  force_destroy = true # Allow deletion for demo purposes

  # Lifecycle Configuration
  lifecycle_enabled                                = true
  lifecycle_rule_id                                = "cleanup-incomplete-uploads"
  lifecycle_rule_status                            = "Enabled"
  lifecycle_abort_incomplete_multipart_upload_days = 3

  # Additional Configuration
  enable_versioning = true
  sse_algorithm     = "AES256"

  tags = {
    Environment = "demo"
    Project     = "lifecycle-example"
    ManagedBy   = "terraform"
  }
}

output "all_module_outputs" {
  description = "All outputs from the S3 Bucket module"
  value       = module.s3_bucket
}
