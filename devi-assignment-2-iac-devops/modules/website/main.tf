############################################################
# S3 WEBSITE BUCKET (PRIVATE - USED WITH CLOUDFRONT OAC)
############################################################

resource "aws_s3_bucket" "website" {
  bucket        = "${var.project_name}-website"
  force_destroy = true
}

############################################################
# VERSIONING
############################################################

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

############################################################
# BLOCK PUBLIC ACCESS (SECURE SETUP)
############################################################

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

############################################################
# STATIC FILES WITH PROPER MIME TYPES
############################################################

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.root}/website-content/index.html"
  etag         = filemd5("${path.root}/website-content/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website.id
  key          = "error.html"
  source       = "${path.root}/website-content/error.html"
  etag         = filemd5("${path.root}/website-content/error.html")
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.website.id
  key          = "style.css"
  source       = "${path.root}/website-content/style.css"
  etag         = filemd5("${path.root}/website-content/style.css")
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.website.id
  key    = "script.js"

  content = templatefile("${path.root}/website-content/script.js.tpl", {
    api_url = var.api_url
  })

  etag         = md5(file("${path.root}/website-content/script.js.tpl"))
  content_type = "application/javascript"
}