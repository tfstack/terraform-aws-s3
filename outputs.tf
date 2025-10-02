output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_bucket_domain_name" {
  description = "The bucket domain name (suitable for direct website hosting)"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_encryption_configuration" {
  description = "The bucket's server-side encryption configuration"
  value = length(aws_s3_bucket.this.server_side_encryption_configuration) > 0 ? {
    sse_algorithm      = aws_s3_bucket.this.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].sse_algorithm
    kms_key_id         = aws_s3_bucket.this.server_side_encryption_configuration[0].rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id
    bucket_key_enabled = aws_s3_bucket.this.server_side_encryption_configuration[0].rule[0].bucket_key_enabled
  } : null
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 hosted zone ID for this bucket"
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_lifecycle_configuration" {
  description = "The bucket's lifecycle configuration"
  value       = length(var.lifecycle_rules) > 0 ? aws_s3_bucket_lifecycle_configuration.this[0].rule : null
}

output "bucket_logging_target" {
  description = "The target bucket for logging (if logging is enabled)"
  value       = var.logging_enabled ? aws_s3_bucket.logging[0].id : null
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_region" {
  description = "The AWS region where the S3 bucket is located"
  value       = aws_s3_bucket.this.region
}

output "bucket_replication_configuration" {
  description = "The bucket's replication configuration"
  value       = length(aws_s3_bucket.this.replication_configuration) > 0 ? aws_s3_bucket.this.replication_configuration[0] : null
}

output "bucket_versioning" {
  description = "The bucket's versioning configuration"
  value       = length(aws_s3_bucket.this.versioning) > 0 ? aws_s3_bucket.this.versioning[0] : null
}
