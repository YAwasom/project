#customize this to change state store name in S3 bucket
terraform {
  backend "s3" {
    key = "ops-cfdlogs.tfstate"
  }
}
