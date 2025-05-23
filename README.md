# terraform-aws-s3

Terraform module to create an S3 bucket

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.94.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
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
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name |
| <a name="output_bucket_hosted_zone_id"></a> [bucket\_hosted\_zone\_id](#output\_bucket\_hosted\_zone\_id) | The Route 53 hosted zone ID for this bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID (name) of the S3 bucket |
| <a name="output_bucket_logging_target"></a> [bucket\_logging\_target](#output\_bucket\_logging\_target) | The target bucket for logging (if logging is enabled) |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | The AWS region where the S3 bucket is located |
