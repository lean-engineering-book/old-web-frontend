provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

variable "build_path" {
  description = "File path for the webapp build directory"
  type = string
}

resource "aws_s3_bucket" "access_logs" {
  bucket = "online-inception-access-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "website" {
  bucket = "online-inception-website"
  acl    = "public-read"

  website {
    index_document = "index.html"    
  }

  logging {
    target_bucket = aws_s3_bucket.access_logs.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_object" "html_files" {
  for_each = fileset(var.build_path, "**/*.html")

  bucket       = aws_s3_bucket.website.bucket
  acl          = "public-read"
  key          = each.value
  source       = "${var.build_path}/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css_files" {
  for_each = fileset(var.build_path, "**/*.css")

  bucket       = aws_s3_bucket.website.bucket
  acl          = "public-read"
  key          = each.value
  source       = "${var.build_path}/${each.value}"
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js_files" {
  for_each = fileset(var.build_path, "**/*.{js,json}")

  bucket       = aws_s3_bucket.website.bucket
  acl          = "public-read"
  key          = each.value
  source       = "${var.build_path}/${each.value}"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_object" "png_files" {
  for_each = fileset(var.build_path, "**/*.png")

  bucket       = aws_s3_bucket.website.bucket
  acl          = "public-read"
  key          = each.value
  source       = "${var.build_path}/${each.value}"
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "ico_files" {
  for_each = fileset(var.build_path, "**/*.ico")

  bucket       = aws_s3_bucket.website.bucket
  acl          = "public-read"
  key          = each.value
  source       = "${var.build_path}/${each.value}"
  content_type = "image/x-icon"
}

resource "aws_s3_bucket_object" "svg_files" {
  for_each = fileset(var.build_path, "**/*.svg")

  bucket       = aws_s3_bucket.website.bucket
  acl          = "public-read"
  key          = each.value
  source       = "${var.build_path}/${each.value}"
  content_type = "image/svg+xml"
}

output "fileset-results" {
  value = fileset(var.build_path, "**/*.{html,css,js,json,png}")
}
