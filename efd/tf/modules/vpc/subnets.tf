resource "aws_subnet" "private_a" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.private_a
  availability_zone = "${var.region}a" 
    tags = {
        Name = "efd${var.efd_env}Stack-Private Subnet A"
        Reach = "private"
    }
}

resource "aws_subnet" "private_b" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.private_b
  availability_zone = "${var.region}b"
    tags = {
        Name = "efd${var.efd_env}Stack-Private Subnet B"
        Reach = "private"
    }
}

resource "aws_subnet" "private_c" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.private_c
  availability_zone = "${var.region}c"
    tags = {
        Name = "efd${var.efd_env}Stack-Private Subnet C"
        Reach = "private"
    }
}
resource "aws_subnet" "public_a" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.public_a
  availability_zone = "${var.region}a"
    tags = {
        Name = "efd${var.efd_env}Stack-Public Subnet A"
        Reach = "public"
    }
}

resource "aws_subnet" "public_b" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.public_b
  availability_zone = "${var.region}b" 
    tags = {
        Name = "efd${var.efd_env}Stack-Public Subnet B"
        Reach = "public"
    }
}

resource "aws_subnet" "public_c" {
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.public_c
  availability_zone = "${var.region}c" 
    tags = {
        Name = "efd${var.efd_env}Stack-Public Subnet C"
        Reach = "public"
    }
}