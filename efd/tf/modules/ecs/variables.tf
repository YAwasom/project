variable "instance_size" {

}

variable "ec2_key" {

}

variable "efd_env" {

}

variable "region" {

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

variable "vpc_cidr" {

}

variable "app" {
    
}

variable "kms_key_id" {
    
}
variable "account_id" {
    
}

variable "image_id" {

}

variable "task_def" {
  
}

variable "priv_subnets" {
  
}
variable "vpc_id" {
  
}
variable "target_group" {
  
}
variable "container_port" {
  
}
