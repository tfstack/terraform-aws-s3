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

  # Lifecycle Configuration - Comprehensive test patterns
  lifecycle_rules = [
    # 1. Basic cleanup rule
    {
      id     = "cleanup-incomplete-uploads"
      status = "Enabled"
      abort_incomplete_multipart_upload = {
        days_after_initiation = 3
      }
    },

    # 2. Log retention with prefix filter
    {
      id     = "expire-old-logs"
      status = "Enabled"
      filter = {
        prefix = "logs/"
      }
      expiration = {
        days = 90
      }
      noncurrent_version_expiration = {
        noncurrent_days = 30
      }
    },

    # 3. Storage class transitions with tag filter
    {
      id     = "transition-to-ia"
      status = "Enabled"
      filter = {
        prefix = "data/"
        tag = {
          key   = "Environment"
          value = "production"
        }
      }
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    },

    # 4. Date-based expiration
    {
      id     = "expire-by-date"
      status = "Enabled"
      filter = {
        prefix = "temp/"
      }
      expiration = {
        date = "2024-12-31T00:00:00Z"
      }
    },

    # 5. Tag-based filtering (single tag only)
    {
      id     = "archive-sensitive-data"
      status = "Enabled"
      filter = {
        tag = {
          key   = "Environment"
          value = "production"
        }
      }
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
        {
          days          = 365
          storage_class = "DEEP_ARCHIVE"
        }
      ]
    },

    # 6. Noncurrent version management only
    {
      id     = "manage-versions"
      status = "Enabled"
      filter = {
        prefix = "backups/"
      }
      noncurrent_version_expiration = {
        noncurrent_days = 7
      }
    },

    # 7. Mixed actions with both prefix and tag
    {
      id     = "comprehensive-rule"
      status = "Enabled"
      filter = {
        prefix = "uploads/"
        tag = {
          key   = "Project"
          value = "webapp"
        }
      }
      expiration = {
        days = 180
      }
      noncurrent_version_expiration = {
        noncurrent_days = 14
      }
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
      ]
    },

    # 8. Disabled rule (for testing)
    {
      id     = "disabled-rule"
      status = "Disabled"
      filter = {
        prefix = "test/"
      }
      expiration = {
        days = 1
      }
    },

    # 9. No filter (entire bucket)
    {
      id     = "global-cleanup"
      status = "Enabled"
      abort_incomplete_multipart_upload = {
        days_after_initiation = 1
      }
    },

    # 10. Complex transition with date
    {
      id     = "date-based-transition"
      status = "Enabled"
      filter = {
        prefix = "archives/"
      }
      transitions = [
        {
          date          = "2024-06-01T00:00:00Z"
          storage_class = "GLACIER"
        }
      ]
    }
  ]

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
