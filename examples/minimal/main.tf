# Fetch AWS Account ID dynamically
data "aws_caller_identity" "current" {}

# Generate a random suffix for bucket name
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
  tags = {
    Environment = "dev"
    Project     = "example-project"
  }
}

# Outputs
output "all_module_outputs" {
  description = "All outputs from the S3 Bucket module"
  value       = module.s3_bucket
}
