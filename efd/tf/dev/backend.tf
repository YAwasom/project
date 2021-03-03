#customize this to change state store name in S3 bucket
terraform {
  backend "s3" {
    key = "aws-wbts-marsefd-dev/efd/dev/ecs/terraform.tfstate"
    profile = "efd-dev"
  }
}
