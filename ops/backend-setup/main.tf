

module "ops-backend" {
  source = "../../tf-modules/backend/setup"
  
  tfregion  = "us-west-2"
  tflocks   = "wb-ops-tflocks"
  tfbucket  = "wb-ops-tfstate"
}