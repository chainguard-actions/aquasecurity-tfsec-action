# Terraform configuration with intentional security issues for testing
resource "aws_s3_bucket" "insecure" {
  bucket = "my-insecure-bucket"
  acl    = "public-read"
}
