
resource "aws_security_group" "efd-ECS-SG" {
  name      = "efd--${var.app}-${var.efd_env}-ECS-SG"
  vpc_id    = var.vpc_id

  ingress {
      from_port     = "443"
      to_port       = "443"
      protocol      = "tcp"
      cidr_blocks   = [var.vpc_cidr]

  }
  ingress {
      from_port     = "80"
      to_port       = "80"
      protocol      = "tcp"
      cidr_blocks   = [var.vpc_cidr]

  }
  ingress {
      from_port     = "8080"
      to_port       = "8080"
      protocol      = "tcp"
      cidr_blocks   = [var.vpc_cidr]

  }
  ingress {
    from_port       = "32768"
    to_port         = "60999"
    protocol        = "tcp"
    cidr_blocks     = [var.vpc_cidr]
  }
  egress {
      from_port     = 0
      to_port       = 0
      protocol      =   "-1"
      cidr_blocks   = ["0.0.0.0/0"]
  }
}

