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

variable "org_id" {
  default = "5d12b285014b763fd28034a3"
}

variable "project_id" {
  default = "5f99e2d5505ad33bc856e57d"
}

variable "provider_instance_size_name" {
  type        = string
  description = "Instance type"
  default     = "M50"
}

variable "provider_backup_enabled" {
  type        = string
  description = "Set to true to enable provider backups for the cluster"
  default     = true
}

variable "disk_size_gb" {
  type        = string
  description = "The size in gigabytes of the server’s root volume. You can add capacity by increasing this number, up to a maximum possible value of 4096 (i.e., 4 TB). This value must be a positive integer."
  default = "300"
}