provider "aws" {
  alias   = "efd-dev"
  region  = var.aws_region
  profile = "efd-dev"
  version = "~> 2.18"
}

provider "mongodbatlas" {}

terraform {
  backend "s3" {
    region         = "us-west-2"
    bucket         = "efd-stg-tf-s3-backend-state"
    key            = "aws-wbts-marsefd-stage/efd/stg/endpoint/terraform.tfstate"
    dynamodb_table = "efd-stg-tf-dynamodb-backend-state-lock"
    encrypt        = true
  }
}

