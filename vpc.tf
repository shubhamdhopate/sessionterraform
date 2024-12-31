resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mainvpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_cidr_block)
  cidr_block              = element(var.public_cidr_block, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_cidr_block)
  cidr_block              = element(var.private_cidr_block, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id
  route  = []
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "publicassociate" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "privateassociate" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privatert.id
  depends_on     = [aws_nat_gateway.mynat]

}

resource "aws_eip" "eip_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "mynat-gateway"
  }
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.privatert.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mynat.id
  depends_on             = [aws_route_table.privatert]
}