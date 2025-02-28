terraform {
  required_version = ">= 1.0"
}

# Fetch AWS Account ID dynamically
data "aws_caller_identity" "current" {}

# Generate a random string as suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Output suffix for use in tests
output "suffix" {
  value = random_string.suffix.result
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = "ap-southeast-2"
}
