# Terraform S3 Bucket Module

This Terraform module creates and manages an **AWS S3 bucket** with **versioning, encryption, IAM access control, and optional logging**.

## Features

- ✅ **Creates an S3 bucket** with a random suffix for uniqueness
- ✅ **Enables versioning** to protect object history
- ✅ **Enforces server-side encryption (`AES256`)** for data security
- ✅ **Configures ownership and access control policies**
- ✅ **Supports IAM principals for restricted access**
- ✅ **Optionally enables logging to a separate bucket**

---

## Usage Example

```hcl
# Fetch AWS Account ID dynamically
data "aws_caller_identity" "current" {}

# Generate a random suffix for uniqueness
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
```

---

## Inputs

| Name                         | Type    | Default | Description |
|------------------------------|---------|---------|-------------|
| `bucket_name`                | `string` | **Required** | Name of the S3 bucket |
| `bucket_suffix`              | `string` | Random | Unique suffix for bucket name |
| `force_destroy`              | `bool`   | `true`  | Force delete non-empty bucket |
| `tags`                       | `map`    | `{}`    | Tags for the bucket |
| `object_ownership`           | `string` | `"BucketOwnerPreferred"` | Ownership setting |
| `bucket_acl`                 | `string` | `"private"` | ACL setting |
| `block_public_acls`          | `bool`   | `true`  | Block public ACLs |
| `block_public_policy`        | `bool`   | `false` | Block public policy |
| `ignore_public_acls`         | `bool`   | `true`  | Ignore public ACLs |
| `restrict_public_buckets`    | `bool`   | `true`  | Restrict public buckets |
| `allowed_principals`         | `list(string)` | `["arn:aws:iam::ACCOUNT_ID:root"]` | IAM principals with access |
| `sse_algorithm`              | `string` | `"AES256"` | Encryption algorithm |
| `enable_versioning`          | `bool`   | `true`  | Enable versioning |
| `logging_enabled`            | `bool`   | `true`  | Enable logging |
| `logging_encryption_enabled` | `bool`   | `true`  | Encrypt log bucket |
| `logging_encryption_algorithm` | `string` | `"AES256"` | Encryption for logs |
| `logging_log_retention_days` | `number` | `90`    | Log retention period |
| `logging_s3_prefix`          | `string` | `"logs/"` | Prefix for logs |

---

## Outputs

| Name               | Description |
|--------------------|-------------|
| `bucket_id`       | The name of the S3 bucket |
| `bucket_arn`      | The ARN of the S3 bucket |
| `bucket_region`   | The AWS region of the bucket |
| `bucket_domain_name` | The domain name of the bucket |
| `bucket_hosted_zone_id` | The Route 53 hosted zone ID for the bucket |
| `bucket_logging_target` | The target logging bucket (if enabled) |

---

## Deployment

### Initialize Terraform

```sh
terraform init
```

### Apply Configuration

```sh
terraform apply -auto-approve
```

### View Outputs

```sh
terraform output
```

### Destroy Resources

```sh
terraform destroy -auto-approve
```

---

## Notes

- **Logging is optional** and can be disabled by setting `logging_enabled = false`.
- **IAM principals can be customized** based on access requirements.
- **Bucket name must be globally unique**, so the suffix ensures no conflicts.

---

## License

This module is released under the **MIT License**.
