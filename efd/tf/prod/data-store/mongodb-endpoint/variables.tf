variable "environment" {
  type        = string
  description = "The environment"
  default     = "prod"
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

#mongo endpoint info
variable "service_name" { default = "com.amazonaws.vpce.us-west-2.vpce-svc-0975688202e26e519" }

variable "subnets_ids" { default = ["subnet-043df76dfcdc27583", "subnet-02494159d1532828e", "subnet-024db6ff6ebc377f3"] }

variable "compute_sg" { default = [ "sg-0c88435a243f176dc" ] }

variable "endpoint_sg_name" { default = "allow_all_ports_efd_prod" }

variable "vpc_id" { default = "vpc-0ff442d077b550a2e" }
