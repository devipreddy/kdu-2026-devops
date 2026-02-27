resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "${var.project_name}-${var.environment}-artifacts"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}