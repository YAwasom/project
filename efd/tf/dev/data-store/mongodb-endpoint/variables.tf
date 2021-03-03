variable "environment" {
  type        = string
  description = "The environment"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "Default aws region"
  default     = "us-west-2"
}

variable "namespace" {
  type        = string
  description = "namespace"
  default     = "wb-cmdt"
}

variable "name" {
  type        = string
  description = "name"
  default     = "efd"
}

#mongo endpoint info - get the service name from Mongo Atlas private endpoint creation

variable "service_name" { default = "com.amazonaws.vpce.us-west-2.vpce-svc-0a624b57cb906ef14" }

variable "subnets_ids" { default = ["subnet-0b0b330f5aeb88b30", "subnet-0f34de08ce9444b8f", "subnet-063eab015584b33a9"] }

variable "compute_sg" { default = ["sg-0fd7d0e7f4b86cae2", "sg-064ca04007ee39bc9", "sg-03e1a756e4d73d489"] }

variable "endpoint_sg_name" { default = "allow_all_ports_efd_dev" }

variable "vpc_id" { default = "vpc-0062376115968fcfc" }

