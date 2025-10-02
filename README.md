# terraform-aws-s3

Terraform module to create an S3 bucket with flexible lifecycle configuration.

## Features

- ✅ **Dynamic Lifecycle Rules** - Flexible configuration supporting any S3 lifecycle pattern
- ✅ **Multiple Rule Types** - Expiration, transitions, cleanup, version management
- ✅ **Flexible Filtering** - Prefix and tag-based filtering
- ✅ **Cost Optimization** - Storage class transitions for cost savings
- ✅ **Version Management** - Noncurrent version expiration support
- ✅ **Security** - Public access blocking and encryption
- ✅ **Logging** - Optional S3 access logging

## Lifecycle Rules Examples

The module supports dynamic lifecycle rules through the `lifecycle_rules` variable. Here are some common patterns:

### Basic Examples

**Simple Expiration:**

```hcl
lifecycle_rules = [
  {
    id     = "expire-after-30-days"
    status = "Enabled"
    expiration = {
      days = 30
    }
  }
]
```

**Cleanup Incomplete Uploads:**

```hcl
lifecycle_rules = [
  {
    id     = "cleanup-incomplete-uploads"
    status = "Enabled"
    abort_incomplete_multipart_upload = {
      days_after_initiation = 7
    }
  }
]
```

**Log Retention with Prefix Filter:**

```hcl
lifecycle_rules = [
  {
    id     = "log-retention"
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
  }
]
```

**Storage Class Transitions:**

```hcl
lifecycle_rules = [
  {
    id     = "cost-optimization"
    status = "Enabled"
    filter = {
      prefix = "data/"
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
  }
]
```

**Tag-based Filtering:**

```hcl
lifecycle_rules = [
  {
    id     = "production-data-retention"
    status = "Enabled"
    filter = {
      tag = {
        key   = "Environment"
        value = "production"
      }
    }
    expiration = {
      days = 2555  # 7 years
    }
  }
]
```

### Supported Rule Types

- `expiration` - Delete objects after specified days/date
- `noncurrent_version_expiration` - Delete noncurrent versions
- `abort_incomplete_multipart_upload` - Clean up failed uploads
- `transitions` - Move objects to different storage classes
- `filter` - Apply rules to specific objects (prefix/tag)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.14.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | List of IAM principals allowed to access the S3 bucket. Use '*' for public access. | `list(string)` | <pre>[<br/>  "*"<br/>]</pre> | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether to block public ACLs on the S3 bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether to block public bucket policies. | `bool` | `true` | no |
| <a name="input_bucket_acl"></a> [bucket\_acl](#input\_bucket\_acl) | The ACL for the S3 bucket | `string` | `"private"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket (must be unique, 3-63 characters, lowercase, and DNS-compliant) | `string` | n/a | yes |
| <a name="input_bucket_suffix"></a> [bucket\_suffix](#input\_bucket\_suffix) | Optional suffix for the S3 bucket name. | `string` | `""` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable versioning for the bucket | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow deletion of non-empty bucket | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether to ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of lifecycle rules for the S3 bucket. Each rule is a map that will be passed directly to the aws_s3_bucket_lifecycle_configuration resource. | `any` | `[]` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Enable logging for the S3 bucket | `bool` | `false` | no |
| <a name="input_logging_encryption_algorithm"></a> [logging\_encryption\_algorithm](#input\_logging\_encryption\_algorithm) | The encryption algorithm used for S3 logging. Valid values: 'AES256', 'aws:kms'. | `string` | `"AES256"` | no |
| <a name="input_logging_encryption_enabled"></a> [logging\_encryption\_enabled](#input\_logging\_encryption\_enabled) | Enable encryption for S3 logging. | `bool` | `true` | no |
| <a name="input_logging_lifecycle_filter_prefix"></a> [logging\_lifecycle\_filter\_prefix](#input\_logging\_lifecycle\_filter\_prefix) | Prefix to apply S3 lifecycle rule to. Set to "" to apply to all objects. | `string` | `""` | no |
| <a name="input_logging_log_retention_days"></a> [logging\_log\_retention\_days](#input\_logging\_log\_retention\_days) | Number of days to retain S3 logging data before expiration. | `number` | `30` | no |
| <a name="input_logging_s3_prefix"></a> [logging\_s3\_prefix](#input\_logging\_s3\_prefix) | Prefix for S3 logging objects. | `string` | `"s3/"` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Defines who owns newly uploaded objects in the bucket. | `string` | `"BucketOwnerPreferred"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether to restrict public access to the bucket. | `bool` | `true` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The encryption algorithm for S3 bucket | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the S3 bucket | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_bucket_bucket_domain_name"></a> [bucket\_bucket\_domain\_name](#output\_bucket\_bucket\_domain\_name) | The bucket domain name (suitable for direct website hosting) |
| <a name="output_bucket_bucket_regional_domain_name"></a> [bucket\_bucket\_regional\_domain\_name](#output\_bucket\_bucket\_regional\_domain\_name) | The bucket region-specific domain name |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name |
| <a name="output_bucket_encryption_configuration"></a> [bucket\_encryption\_configuration](#output\_bucket\_encryption\_configuration) | The bucket's server-side encryption configuration |
| <a name="output_bucket_hosted_zone_id"></a> [bucket\_hosted\_zone\_id](#output\_bucket\_hosted\_zone\_id) | The Route 53 hosted zone ID for this bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the S3 bucket |
| <a name="output_bucket_lifecycle_configuration"></a> [bucket\_lifecycle\_configuration](#output\_bucket\_lifecycle\_configuration) | The bucket's lifecycle configuration |
| <a name="output_bucket_logging_target"></a> [bucket\_logging\_target](#output\_bucket\_logging\_target) | The target bucket for logging (if logging is enabled) |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the S3 bucket |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | The AWS region where the S3 bucket is located |
| <a name="output_bucket_replication_configuration"></a> [bucket\_replication\_configuration](#output\_bucket\_replication\_configuration) | The bucket's replication configuration |
| <a name="output_bucket_versioning"></a> [bucket\_versioning](#output\_bucket\_versioning) | The bucket's versioning configuration |
<!-- END_TF_DOCS -->
