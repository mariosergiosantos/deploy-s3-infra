provider "aws" {
  region  = "${var.region}"
}

resource "aws_s3_bucket" "deploy_s3_demo" {
  bucket = "deploy-s3-demo-${var.environment}"

  tags = {
    environment = "${var.environment}"
    project     = "deploy-s3"
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

# resource "aws_cloudfront_distribution" "s3_distribution" {
#   origin {
#     domain_name              = aws_s3_bucket.deploy_s3_demo.bucket_regional_domain_name
#     origin_id                = local.s3_origin_id
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "Some comment"
#   default_root_object = "index.html"

#   aliases = ["mysite.example.com", "yoursite.example.com"]

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "allow-all"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   # Cache behavior with precedence 0
#   ordered_cache_behavior {
#     path_pattern     = "/content/immutable/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false
#       headers      = ["Origin"]

#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl                = 0
#     default_ttl            = 86400
#     max_ttl                = 31536000
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

#   # Cache behavior with precedence 1
#   ordered_cache_behavior {
#     path_pattern     = "/content/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

#   price_class = "PriceClass_200"

#   restrictions {
#     geo_restriction {
#       restriction_type = "whitelist"
#       locations        = ["US", "CA", "GB", "DE"]
#     }
#   }

#   tags = {
#     Environment = "${var.environment}"
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }
# }

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.deploy_s3_demo.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "PublicReadGetObject",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "${aws_s3_bucket.deploy_s3_demo.arn}/*"
        ]
      }
    ]
  })
}
