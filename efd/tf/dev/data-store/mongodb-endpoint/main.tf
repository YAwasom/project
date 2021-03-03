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
    bucket         = "efd-dev-tf-s3-backend-state"
    key            = "aws-wbts-marsefd-dev/efd/dev/endpoint/terraform.tfstate"
    dynamodb_table = "efd-dev-tf-dynamodb-backend-state-lock"
    encrypt        = true
  }
}

