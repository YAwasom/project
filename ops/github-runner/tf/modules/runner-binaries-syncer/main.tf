locals {
  action_runner_distribution_object_key = "actions-runner-linux.tar.gz"
}

resource "aws_s3_bucket_policy" "action_dist" {
  bucket = aws_s3_bucket.action_dist.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "dist-bucket-policy"
    Statement = [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          aws_s3_bucket.action_dist.arn,
          "${aws_s3_bucket.action_dist.arn}/*",
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "action_dist" {
  bucket = aws_s3_bucket.action_dist.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket_policy.action_dist
  ]
}

resource "aws_s3_bucket" "action_dist" {
  bucket        = var.distribution_bucket_name
  acl           = "private"
  force_destroy = true
  tags          = var.tags

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "Abort Incomplete Multipart Uploads"
    prefix  = "*"
    enabled = true
    abort_incomplete_multipart_upload_days = 10
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
