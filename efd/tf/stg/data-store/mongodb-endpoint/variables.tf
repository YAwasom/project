variable "environment" {
  type        = string
  description = "The environment"
  default     = "stg"
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

variable "service_name" { default = "com.amazonaws.vpce.us-west-2.vpce-svc-0724e080b15b0d45e" }

variable "subnets_ids" { default = ["subnet-00fde92c289a729d7", "subnet-0c27cdd9cbf104d1f", "subnet-049e3f2c33b843099"] }

variable "compute_sg" { default = [ "sg-0c1a80ee11e4f8aa1" ] }

variable "endpoint_sg_name" { default = "allow_all_ports_efd_stg" }

variable "vpc_id" { default = "vpc-00319ada28c71196e" }

