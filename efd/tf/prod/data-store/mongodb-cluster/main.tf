provider "aws" {
  alias   = "aws-wbts-marsefd-prod"
  region  = var.aws_region
  profile = "efd-prod"
  version = "~> 2.18"
}

provider "mongodbatlas" {}

terraform {
  backend "s3" {
    region         = "us-west-2"
    bucket         = "efd-prod-tf-s3-backend-state"
    key            = "aws-wbts-marsefd-prod/efd/prod/terraform.tfstate"
    dynamodb_table = "efd-prod-tf-dynamodb-backend-state-lock"
    encrypt        = true
  }
}
