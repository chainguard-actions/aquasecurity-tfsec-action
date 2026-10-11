# Terraform configuration with intentional security issues
# Used for tfsec soft_fail test

resource "aws_s3_bucket" "insecure" {
  bucket = "my-insecure-bucket"
  acl    = "public-read"
}
