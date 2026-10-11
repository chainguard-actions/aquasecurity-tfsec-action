# Intentionally insecure S3 bucket to trigger tfsec findings
resource "aws_s3_bucket" "insecure" {
  bucket = "my-insecure-bucket"
  acl    = "public-read"
}
