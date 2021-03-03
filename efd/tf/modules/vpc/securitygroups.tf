#ToDo: Cidr blocks need to become variables to abstract to run for different environments

resource "aws_security_group" "efd-ECS-SG" {
  name      = "efd-ECS-SG"
  vpc_id    = aws_vpc.main.id

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



resource "aws_security_group" "efd-ALB-Inbound" {
  name      = "efd-ALB-Inbound"
  vpc_id    = aws_vpc.main.id

  ingress {
      from_port     = "443"
      to_port       = "443"
      protocol      = "tcp"
      cidr_blocks   =  var.ingress_access #WB Only

  }
  ingress {
      from_port     = "80"
      to_port       = "80"
      protocol      = "tcp"
      cidr_blocks   =  var.ingress_access #WB Only

  }
  egress {
      from_port     = 0
      to_port       = 0
      protocol      =   "-1"
      cidr_blocks   = ["0.0.0.0/0"]
  }
}
