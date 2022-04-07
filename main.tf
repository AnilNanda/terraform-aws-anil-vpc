terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}


resource "aws_vpc" "web_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "web-vpc"
  }
}

resource "aws_subnet" "web_public_1a" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.1.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "web-public-1a"
  }
}

resource "aws_subnet" "web_public_1b" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.1.128/25"
  availability_zone = "us-east-1b"

  tags = {
    Name = "web-public-1b"
  }
}

resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name    = "web-dev-igw"
  }
}

# Build route table 1
resource "aws_route_table" "web_rt" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_igw.id
  }

  tags = {
    Name = "web-dev-rt"
  }
}

#Associate RT with subnet
resource "aws_route_table_association" "dev-rt-association" {
  subnet_id      = aws_subnet.web_public_1a.id
  route_table_id = aws_route_table.web_rt.id
}

output "vpc_id" {
  value = aws_vpc.web_vpc.id
}

output "subnet_id" {
  value = aws_subnet.web_public_1a.id
  
}