provider "aws" {
  region  = "${var.region}"
}

resource "aws_s3_bucket" "deploy_s3_demo" {
  bucket = "deploy-s3-demo-${var.environment}"
  
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_website_configuration" "deploy_s3_demo_website" {
  bucket = aws_s3_bucket.deploy_s3_demo.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
