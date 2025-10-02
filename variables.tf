############################################
# GENERAL BUCKET CONFIGURATION VARIABLES
############################################

variable "bucket_name" {
  description = "The name of the S3 bucket (must be unique, 3-63 characters, lowercase, and DNS-compliant)"
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters long, lowercase, contain only letters, numbers, dots (.), and hyphens (-), and must not start or end with a dot or hyphen."
  }
}

variable "bucket_suffix" {
  description = "Optional suffix for the S3 bucket name."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Whether to allow deletion of non-empty bucket"
  type        = bool
  default     = false
}

variable "bucket_acl" {
  description = "The ACL for the S3 bucket"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control"], var.bucket_acl)
    error_message = "Allowed values for bucket_acl are 'private', 'public-read', 'public-read-write', 'authenticated-read', 'aws-exec-read', 'bucket-owner-read', or 'bucket-owner-full-control'."
  }
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "The encryption algorithm for S3 bucket"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "Allowed values for sse_algorithm are 'AES256' or 'aws:kms'."
  }
}

variable "object_ownership" {
  description = "Defines who owns newly uploaded objects in the bucket."
  type        = string
  default     = "BucketOwnerPreferred"

  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "The object ownership setting must be one of 'BucketOwnerPreferred', 'ObjectWriter', or 'BucketOwnerEnforced'."
  }
}

############################################
# PUBLIC ACCESS & SECURITY SETTINGS
############################################

variable "block_public_acls" {
  description = "Whether to block public ACLs on the S3 bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether to block public bucket policies."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public access to the bucket."
  type        = bool
  default     = true
}

variable "allowed_principals" {
  description = "List of IAM principals allowed to access the S3 bucket. Use '*' for public access."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.allowed_principals) > 0
    error_message = "The allowed_principals list cannot be empty."
  }
}

############################################
# LOGGING CONFIGURATION VARIABLES
############################################

variable "logging_enabled" {
  description = "Enable logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "logging_encryption_enabled" {
  description = "Enable encryption for S3 logging."
  type        = bool
  default     = true
}

variable "logging_encryption_algorithm" {
  description = "The encryption algorithm used for S3 logging. Valid values: 'AES256', 'aws:kms'."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.logging_encryption_algorithm)
    error_message = "Allowed values for logging_encryption_algorithm are 'AES256' or 'aws:kms'."
  }
}

variable "logging_lifecycle_filter_prefix" {
  description = "Prefix to apply S3 lifecycle rule to. Set to \"\" to apply to all objects."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9!_.*'()/~\\-]*$", var.logging_lifecycle_filter_prefix))
    error_message = "The lifecycle prefix must be a valid S3 object key prefix or an empty string."
  }
}

variable "logging_log_retention_days" {
  description = "Number of days to retain S3 logging data before expiration."
  type        = number
  default     = 30

  validation {
    condition     = var.logging_log_retention_days > 0
    error_message = "The retention period must be greater than 0 days."
  }
}

variable "logging_s3_prefix" {
  description = "Prefix for S3 logging objects."
  type        = string
  default     = "s3/"

  validation {
    condition     = can(regex("^[a-zA-Z0-9!_.*'()/~-]+$", var.logging_s3_prefix))
    error_message = "The logging S3 prefix must be a valid S3 object key prefix, containing only alphanumeric characters and special characters like ! _ . * ' ( ) / ~ -."
  }
}

############################################
# LIFECYCLE CONFIGURATION
############################################

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket. Each rule is a map that will be passed directly to the aws_s3_bucket_lifecycle_configuration resource."
  type        = any
  default     = []

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      contains(keys(rule), "id") && contains(keys(rule), "status")
    ])
    error_message = "Each lifecycle rule must have 'id' and 'status' keys."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      length(rule.id) > 0 && length(rule.id) <= 255
    ])
    error_message = "Each lifecycle rule ID must be between 1 and 255 characters."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules :
      contains(["Enabled", "Disabled"], rule.status)
    ])
    error_message = "Each lifecycle rule status must be 'Enabled' or 'Disabled'."
  }
}

############################################
# TAGS CONFIGURATION
############################################

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) > 0])
    error_message = "All tag keys and values must be non-empty strings."
  }
}
