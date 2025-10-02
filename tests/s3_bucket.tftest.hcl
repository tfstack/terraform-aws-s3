run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "test_s3_bucket" {
  variables {
    bucket_name   = "test-s3-bucket"
    bucket_suffix = run.setup.suffix
    force_destroy = true
    tags = {
      Environment = "dev"
      Project     = "example-project"
    }

    # Ownership & Access Control
    object_ownership   = "BucketOwnerPreferred"
    bucket_acl         = "private"
    allowed_principals = ["arn:aws:iam::${run.setup.account_id}:root"]

    # Public Access Configuration
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = true

    # Security & Encryption
    sse_algorithm = "AES256"

    # Versioning
    enable_versioning = true

    # Lifecycle Configuration
    lifecycle_rules = [
      {
        id     = "cleanup-incomplete-uploads"
        status = "Enabled"
        filter = {
          prefix = ""
        }
        abort_incomplete_multipart_upload = {
          days_after_initiation = 1
        }
      }
    ]

    # Logging Configuration
    logging_enabled                 = true
    logging_encryption_enabled      = true
    logging_encryption_algorithm    = "AES256"
    logging_log_retention_days      = 90
    logging_s3_prefix               = "logs/"
    logging_lifecycle_filter_prefix = "logs/"
  }

  # Assertions referencing actual Terraform resources

  assert {
    condition     = aws_s3_bucket.this.bucket == "test-s3-bucket-${run.setup.suffix}"
    error_message = "Bucket name does not match expected value."
  }

  assert {
    condition     = aws_s3_bucket_acl.this.acl == "private"
    error_message = "Bucket ACL is not set to 'private'."
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.this.rule[0].object_ownership == "BucketOwnerPreferred"
    error_message = "Object ownership is not set to 'BucketOwnerPreferred'."
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "Versioning is not enabled."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_policy == false
    error_message = "Block public policy should be set to 'false'."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls == true
    error_message = "Block public ACLs should be set to 'true'."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.ignore_public_acls == true
    error_message = "Ignore public ACLs should be set to 'true'."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.restrict_public_buckets == true
    error_message = "Restrict public buckets should be set to 'true'."
  }

  assert {
    condition     = flatten([for rule in aws_s3_bucket_server_side_encryption_configuration.this.rule : rule.apply_server_side_encryption_by_default[*].sse_algorithm]) == ["AES256"]
    error_message = "SSE algorithm is not set to 'AES256'."
  }

  assert {
    condition     = aws_s3_bucket_logging.logging[0].target_bucket == "${aws_s3_bucket.this.id}-logs"
    error_message = "Logging target bucket does not match expected value."
  }

  assert {
    condition     = aws_s3_bucket_logging.logging[0].target_prefix == "logs/"
    error_message = "Logging S3 prefix is not set to 'logs/'."
  }

  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.logging[0].rule[0].filter[0].prefix == "logs/"
    error_message = "Lifecycle rule prefix is not set to the expected value 'logs/'."
  }

  # Test main bucket lifecycle configuration
  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.this[0].rule[0].id == "cleanup-incomplete-uploads"
    error_message = "Main bucket lifecycle rule ID is not set to 'cleanup-incomplete-uploads'."
  }

  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.this[0].rule[0].status == "Enabled"
    error_message = "Main bucket lifecycle rule status is not 'Enabled'."
  }

  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.this[0].rule[0].abort_incomplete_multipart_upload[0].days_after_initiation == 1
    error_message = "Main bucket lifecycle abort incomplete multipart upload days is not set to 1."
  }
}
