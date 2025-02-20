output "bucket_id" {
  description = "The ID (name) of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_region" {
  description = "The AWS region where the S3 bucket is located"
  value       = aws_s3_bucket.this.region
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 hosted zone ID for this bucket"
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "bucket_logging_target" {
  description = "The target bucket for logging (if logging is enabled)"
  value       = var.logging_enabled ? aws_s3_bucket.logging[0].id : null
}
