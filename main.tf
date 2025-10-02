locals {
  base_bucket_name = (
    var.bucket_suffix == "" ?
    var.bucket_name :
  "${var.bucket_name}-${var.bucket_suffix}")
}

############################################
# S3 BUCKET CONFIGURATION
############################################

resource "aws_s3_bucket" "this" {
  bucket        = local.base_bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.bucket_acl

  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.lifecycle_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id     = var.lifecycle_rule_id
    status = var.lifecycle_rule_status

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.lifecycle_abort_incomplete_multipart_upload_days
    }
  }

  # Validation to ensure lifecycle rule is properly configured
  lifecycle {
    precondition {
      condition     = var.lifecycle_enabled == false || (var.lifecycle_rule_status == "Enabled" || var.lifecycle_rule_status == "Disabled")
      error_message = "Lifecycle rule status must be 'Enabled' or 'Disabled' when lifecycle is enabled."
    }

    precondition {
      condition     = var.lifecycle_enabled == false || var.lifecycle_abort_incomplete_multipart_upload_days > 0
      error_message = "Lifecycle abort incomplete multipart upload days must be greater than 0 when lifecycle is enabled."
    }

    precondition {
      condition     = var.lifecycle_enabled == false || (length(var.lifecycle_rule_id) > 0 && length(var.lifecycle_rule_id) <= 255)
      error_message = "Lifecycle rule ID must be between 1 and 255 characters when lifecycle is enabled."
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.block_public_policy == false ? 1 : 0

  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
        Principal = {
          AWS = join(",", var.allowed_principals)
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

############################################
# S3 LOGGING CONFIGURATION
############################################

resource "aws_s3_bucket" "logging" {
  count = var.logging_enabled ? 1 : 0

  bucket        = "${local.base_bucket_name}-logs"
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { Name = "${local.base_bucket_name}-logs" })
}

resource "aws_s3_bucket_ownership_controls" "logging" {
  count = var.logging_enabled ? 1 : 0

  bucket = aws_s3_bucket.logging[0].id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  count = var.logging_enabled && var.logging_encryption_enabled ? 1 : 0

  bucket = aws_s3_bucket.logging[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.logging_encryption_algorithm
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  count = var.logging_enabled ? 1 : 0

  bucket = aws_s3_bucket.logging[0].id

  rule {
    id     = "log-retention"
    status = "Enabled"

    filter {
      prefix = var.logging_lifecycle_filter_prefix
    }

    expiration {
      days = var.logging_log_retention_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.logging_log_retention_days
    }
  }
}

resource "aws_s3_bucket_logging" "logging" {
  count = var.logging_enabled ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.logging[0].id
  target_prefix = var.logging_s3_prefix

  depends_on = [
    aws_s3_bucket.logging
  ]
}
