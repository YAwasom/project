
provider "aws" {
    version = "~> 2.0"
    region = var.region
 
}

resource "aws_s3_bucket" "cfd-logs" {
    bucket = "wb-cmd-ops-cfd-logs"
    policy = data.aws_iam_policy_document.cfd-logs-policy.json

    lifecycle_rule {
    id      = "All"
    prefix  = "*"
    enabled = true

    expiration {
      days = "30"
    }
  }

    server_side_encryption_configuration {
     rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
     }
    }
    grant {
        id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type        = "CanonicalUser"
        permissions = ["FULL_CONTROL"]
  }
    grant {
        id          = "84daee7f97cecbabd1d4cbf3d4d00dca4f990b8c034a3bf6fe65e97f58ae4895"
        type        = "CanonicalUser"
        permissions = ["FULL_CONTROL"]
    }
}

resource "aws_s3_bucket_public_access_block" "cfd-logs"{
    bucket = aws_s3_bucket.cfd-logs.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true

}

data "aws_iam_policy_document" "cfd-logs-policy"{
    statement {
        effect = "Allow"
        principals {
            type            = "AWS"
            identifiers     = ["arn:aws:iam::147180035125:root","arn:aws:iam::077047573990:root","arn:aws:iam::507416135429:root"]
        }
        actions = [
            "s3:PutBucketAcl",
            "s3:GetBucketAcl"
        ]

        resources = [
            "arn:aws:s3:::${var.bucketname}"
        ]
        condition {
          test      = "Bool"
          variable  = "aws:SecureTransport"
          values    = ["true"]
        }
    }

}

