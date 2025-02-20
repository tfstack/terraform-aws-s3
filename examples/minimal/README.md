# Terraform S3 Bucket Module

This Terraform module provisions an **AWS S3 bucket** with optional configuration settings for **naming, tagging, and unique suffix generation**.

## Features

- ✅ **Creates an S3 bucket** with a unique random suffix
- ✅ **Supports custom bucket naming**
- ✅ **Allows custom tagging** for environment and project identification

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
```

---

## Inputs

| Name            | Type    | Default | Description |
|-----------------|---------|---------|-------------|
| `bucket_name`   | `string` | **Required** | Name of the S3 bucket |
| `bucket_suffix` | `string` | Random | Unique suffix for bucket name |
| `tags`          | `map`    | `{}`    | Tags for the bucket |

---

## Outputs

| Name               | Description |
|--------------------|-------------|
| `bucket_id`       | The name of the S3 bucket |
| `bucket_arn`      | The ARN of the S3 bucket |
| `bucket_region`   | The AWS region of the bucket |

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

- **Bucket name must be globally unique**, so the suffix ensures no conflicts.
- **IAM permissions may be required** to manage the bucket in AWS.

---

## License

This module is released under the **MIT License**.
