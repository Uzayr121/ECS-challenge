resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = var.public_subnet_name_1
  }
}
resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = var.public_subnet_name_2
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = var.private_subnet_name_1
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = var.private_subnet_name_2
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.internet_gway
  }
}


resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = var.nat_gway
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = var.nat_gway
  }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
      Name = var.public_route_table_name
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
      Name = var.private_route_table_name
    }
}
# Route table association for first public subnet
resource "aws_route_table_association" "public_1_association" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

# Route table association for second public subnet
resource "aws_route_table_association" "public_2_association" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Route table association for first private subnet
resource "aws_route_table_association" "private_1_association" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}
# Route table association for second private subnet
resource "aws_route_table_association" "private_2_association" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}