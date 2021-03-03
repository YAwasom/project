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

variable "org_id" {
  default = "5d12b285014b763fd28034a3"
}

variable "project_id" {
  default = "5f99e2a2466c9d75286ae216"
}

