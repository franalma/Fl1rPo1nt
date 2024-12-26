terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "eu-west-3"
  profile = "floiint"
}


# VPC
resource "aws_vpc" "vpc_floiint_t" {

  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "vpc-floiint-t"
    "Terraform" = "Yes"
  }
}

# Create a Security Group
resource "aws_security_group" "sec_group_floiint" {
  name        = "floiint-t"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.vpc_floiint_t.id

  # Inbound rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere (adjust for security)
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name       = "sg-floiint-t"
    "Terrarom" = true
  }
}


resource "aws_subnet" "public_subnet_floiint" {
  vpc_id                  = aws_vpc.vpc_floiint_t.id
  cidr_block              = "172.31.2.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "subnet-public-floiint-t"
    "Terraform" = "Yes"
  }
}

resource "aws_subnet" "private_subnet_floiint" {
  vpc_id                  = aws_vpc.vpc_floiint_t.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "subnet-private-floiint-t"
    "Terraform" = "Yes"
  }
}


resource "aws_internet_gateway" "igw_floiint" {
  vpc_id = aws_vpc.vpc_floiint_t.id
  tags = {
    Name        = "igw-floiint-t"
    "Terraform" = "Yes"
  }
}


resource "aws_route_table" "floiint_public_route_table" {

  vpc_id = aws_vpc.vpc_floiint_t.id
  tags = {
    Name        = "rtb-floiint-public-route"
    "Terraform" = "Yes"
  }

  route {
    cidr_block = "0.0.0.0/0" # Route for all outbound traffic
    gateway_id = aws_internet_gateway.igw_floiint.id
  }
}

resource "aws_route_table_association" "public_floiint_association" {
  subnet_id      = aws_subnet.public_subnet_floiint.id
  route_table_id = aws_route_table.floiint_public_route_table.id
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name        = "nat-eip"
    "Terraform" = "Yes"
  }
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat_gw_floiiint" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_floiint.id

  tags = {
    Name        = "nat-gateway-floiint-t"
    "Terraform" = "Yes"
  }
}


resource "aws_route_table" "floiint_private_route_table" {

  vpc_id = aws_vpc.vpc_floiint_t.id
  tags = {
    Name        = "rtb-floiint-private-route"
    "Terraform" = "Yes"
  }

  route {
    cidr_block = "0.0.0.0/0" # Route for all outbound traffic
    gateway_id = aws_nat_gateway.nat_gw_floiiint.id
  }
}


resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet_floiint.id
  route_table_id = aws_route_table.floiint_private_route_table.id
}


# EC2 instances
# resource "aws_instance" "ec2_floiint_web_server" {
#   ami                         = "ami-0b70357cd87d64d6a"
#   instance_type               = "t2.micro"
#   security_groups             = [aws_security_group.sec_group_floiint.id]
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public_subnet_floiint.id
#   key_name                    = "floiint-web-server"


#   tags = {
#     Name        = "ec2-floiint-web-server"
#     "Terraform" = true
#   }

# }

resource "aws_instance" "ec2_floiint_db_server" {
  ami             = "ami-06295cf54a2a15527"
  instance_type   = "t2.small"
  security_groups = [aws_security_group.sec_group_floiint.id]
  subnet_id       = aws_subnet.private_subnet_floiint.id
  key_name        = "floiint-web-server"

  tags = {
    Name        = "ec2-floiint-db-server-1"
    "Terraform" = true
  }
}




