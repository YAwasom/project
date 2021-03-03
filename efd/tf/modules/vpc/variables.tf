variable "instance_size" {

}

variable "ec2_key" {

}

variable "efd_env" {

}

variable "region" {

}

variable "ecs_wstdeffile" {
  type        = string
  description = ""
  default     = "ecstask-ws.json"
}

variable "ecs_surlytdeffile" {
  type        = string
  description = ""
  default     = "ecstask-surly.json"
}

variable "ecs_templatefile"{
  type        = string
  description = ""
  default     = "ecs-template.sh"
}

variable "ingress_access" {

}

variable "vpc_cidr" {

}

variable "private_a" {

}

variable "private_b" {

}
variable "private_c" {

}
variable "public_a" {

}

variable "public_b" {
    
}

variable "public_c" {
    
}
variable "cloudwatch_file"{
  default     = "cloudwatch.json"
}


variable "peer_id" {
    
}

variable "peer_cidr" {
    
}