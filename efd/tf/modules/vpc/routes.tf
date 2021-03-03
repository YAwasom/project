resource "aws_route_table" "routetable-Public" {
    vpc_id    =   aws_vpc.main.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "efd${var.efd_env}Stack-Public"
    }
}

resource "aws_route_table" "routetable-private_a" {
    vpc_id    =   aws_vpc.main.id

    route {
        cidr_block  = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.gwa.id
    }

    tags = {
        Name = "efd${var.efd_env}Stack-private_a"
    }
}

resource "aws_route_table" "routetable-private_b" {
    vpc_id    =   aws_vpc.main.id

    route {
        cidr_block  = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.gwb.id
    }

    tags = {
        Name = "efd${var.efd_env}Stack-private_b"
    }
}
resource "aws_route_table" "routetable-private_c" {
    vpc_id    =   aws_vpc.main.id

    route {
        cidr_block  = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.gwc.id
    }

    tags = {
        Name = "efd${var.efd_env}Stack-private_c"
    }
}


resource "aws_route_table_association" "public_a" {
  subnet_id         =   aws_subnet.public_a.id
  route_table_id    =   aws_route_table.routetable-Public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id         =   aws_subnet.public_b.id
  route_table_id    =   aws_route_table.routetable-Public.id
}
resource "aws_route_table_association" "public_c" {
  subnet_id         =   aws_subnet.public_c.id
  route_table_id    =   aws_route_table.routetable-Public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id         =   aws_subnet.private_a.id
  route_table_id    =   aws_route_table.routetable-private_a.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id         =   aws_subnet.private_b.id
  route_table_id    =   aws_route_table.routetable-private_b.id
}
resource "aws_route_table_association" "private_c" {
  subnet_id         =   aws_subnet.private_c.id
  route_table_id    =   aws_route_table.routetable-private_c.id
}


resource "aws_route_table" "routetable_todevold" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block    = var.peer_cidr
        vpc_peering_connection_id = aws_vpc_peering_connection.efd-dev-peer.id
    }
}

resource "aws_route_table" "routetable_fromdevold" {
    vpc_id = var.peer_id

    route {
        cidr_block    = var.vpc_cidr
        vpc_peering_connection_id = aws_vpc_peering_connection.efd-dev-peer.id
    }
}