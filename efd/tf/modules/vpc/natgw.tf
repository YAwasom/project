resource "aws_nat_gateway" "gwa" {
  allocation_id     = aws_eip.natgwa.id
  subnet_id         = aws_subnet.public_a.id

  tags = {
      Name  = "efd${var.efd_env}-Nat-PrivateGWa"
  }

  depends_on    =   [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gwb" {
  allocation_id     = aws_eip.natgwb.id
  subnet_id         = aws_subnet.public_b.id

  tags = {
      Name  = "efd${var.efd_env}-Nat-PrivateGWb"
  }

  depends_on    =   [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gwc" {
  allocation_id     = aws_eip.natgwc.id
  subnet_id         = aws_subnet.public_c.id

  tags = {
      Name  = "efd${var.efd_env}-Nat-PrivateGWc"
  }

  depends_on    =   [aws_internet_gateway.gw]
}
