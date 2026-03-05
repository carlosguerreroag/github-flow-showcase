# -------------------------------------------------
# ----------------- S3 BACKEND --------------------
# -------------------------------------------------
resource "aws_s3_bucket" "tf_backend" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# -------------------------------------------------
# ----------------- DYNAMODB TF LOCK --------------
# -------------------------------------------------
resource "aws_dynamodb_table" "tf_locks" {
  name         = var.dynamodb_locks_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    ManagedBy = "Terraform"
  }
}
