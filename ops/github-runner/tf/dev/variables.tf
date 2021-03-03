variable "environment" {
  default = "dev"
}

variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {
  # wb-cmd-ops-vpc
  default = "vpc-02f651ead85e1e0bc"
}

variable "private_subnet_id_a" {
  # wb-cmd-ops-vpc-private-subnet-*
  default = "subnet-00892dbc84fe55347"
}

variable "private_subnet_id_b" {
  # wb-cmd-ops-vpc-private-subnet-*
  default = "subnet-07a8ab3451afbe56f"
}

variable "private_subnet_id_c" {
  # wb-cmd-ops-vpc-private-subnet-*
  default = "subnet-05c3cd3688809ce2b"
}

variable "github_app_id" {
  default = "99349"
}
