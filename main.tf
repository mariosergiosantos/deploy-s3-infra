provider "aws" {
  region  = "${var.region}"
}

resource "aws_s3_bucket" "deploy_s3_demo" {
  bucket = "deploy-s3-demo-${var.environment}"
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

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.deploy_s3_demo.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "Permissions S3",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:GetBucketPolicy",
          "s3:GetBucketTagging",
          "s3:GetBucketWebsite",
          "s3:CreateBucket",
          "s3:DeleteBucketWebsite",
          "s3:DeleteBucket"
        ],
        Resource = [
          "${aws_s3_bucket.deploy_s3_demo.arn}/*"
        ]
      }
    ]
  })
}
