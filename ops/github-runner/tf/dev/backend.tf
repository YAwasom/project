# Customize this to change state store name in S3 bucket
terraform {
  backend "s3" {
    key = "ops/github-runner/dev/terraform.tfstate"
    profile = "ops"
  }
}