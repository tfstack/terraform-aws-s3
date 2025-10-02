# S3 Bucket with Lifecycle Configuration

This Terraform module provisions an **AWS S3 bucket** with **lifecycle configuration** for automatic cleanup of incomplete multipart uploads.

## Features

- ✅ **Creates an S3 bucket** with lifecycle policies
- ✅ **Automatic cleanup** of incomplete multipart uploads
- ✅ **Configurable retention** period for cleanup
- ✅ **Versioning enabled** for data protection
- ✅ **Server-side encryption** with AES256

---

## Usage Example

```hcl
# Generate a random suffix for uniqueness
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
  force_destroy = true

  # Lifecycle Configuration
  lifecycle_enabled = true
  lifecycle_rule_id = "cleanup-incomplete-uploads"
  lifecycle_rule_status = "Enabled"
  lifecycle_abort_incomplete_multipart_upload_days = 3

  # Additional Configuration
  enable_versioning = true
  sse_algorithm = "AES256"

  tags = {
    Environment = "demo"
    Project     = "lifecycle-example"
    ManagedBy   = "terraform"
  }
}

# Outputs
output "all_module_outputs" {
  description = "All outputs from the S3 Bucket module"
  value       = module.s3_bucket
}
```

---

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `bucket_name` | `string` | **Required** | Name of the S3 bucket |
| `bucket_suffix` | `string` | Random | Unique suffix for bucket name |
| `lifecycle_enabled` | `bool` | `false` | Enable lifecycle configuration |
| `lifecycle_rule_id` | `string` | `"cleanup-incomplete-uploads"` | Unique ID for the lifecycle rule |
| `lifecycle_rule_status` | `string` | `"Disabled"` | Status: "Enabled" or "Disabled" |
| `lifecycle_abort_incomplete_multipart_upload_days` | `number` | `1` | Days before cleaning up incomplete uploads |
| `enable_versioning` | `bool` | `true` | Enable versioning for the bucket |
| `sse_algorithm` | `string` | `"AES256"` | Server-side encryption algorithm |
| `tags` | `map` | `{}` | Tags for the bucket |

---

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | The ID of the S3 bucket |
| `bucket_name` | The name of the S3 bucket |
| `bucket_arn` | The ARN of the S3 bucket |
| `bucket_region` | The AWS region of the bucket |
| `bucket_lifecycle_configuration` | The bucket's lifecycle configuration |
| `bucket_versioning` | The bucket's versioning configuration |
| `bucket_encryption_configuration` | The bucket's encryption configuration |

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

- **Lifecycle configuration** automatically cleans up incomplete multipart uploads to reduce storage costs
- **Bucket name must be globally unique**, so the suffix ensures no conflicts
- **IAM permissions may be required** to manage the bucket in AWS

---

## License

This example is released under the **MIT License**.
