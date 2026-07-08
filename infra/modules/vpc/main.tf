# ------------------------------------------------------------------------------
# 2. CORE NETWORK (VPC)
# ------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "threat-composer-vpc"
  }
}

#--------------------
locals {
  subnets = {
    "public-a"  = { cidr = "10.0.1.0/24", az = "eu-north-1a", public = true }
    "public-b"  = { cidr = "10.0.2.0/24", az = "eu-north-1b", public = true }
    "private-a" = { cidr = "10.0.10.0/24", az = "eu-north-1a", public = false }
    "private-b" = { cidr = "10.0.11.0/24", az = "eu-north-1b", public = false }
  }
}


#Create the Subnets with One Block:

resource "aws_subnet" "network" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}
#-------------------------------------------



# # ------------------------------------------------------------------------------
# # 3. PRIVATE SUBNETS (AZ A & B)
# # ------------------------------------------------------------------------------

# resource "aws_subnet" "private_a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "eu-north-1a"

#   tags = {
#     Name = "threat-composer-private-subnet-a"
#   }
# }

# resource "aws_subnet" "private_b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "eu-north-1b"

#   tags = {
#     Name = "threat-composer-private-subnet-b"
#   }
# }

# ------------------------------------------------------------------------------
# 4. PRIVATE ROUTE TABLE & ASSOCIATIONS
# ------------------------------------------------------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "threat-composer-private-rt"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.network["private-a"].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.network["private-b"].id
  route_table_id = aws_route_table.private.id
}

# ------------------------------------------------------------------------------
# 5. PUBLIC NETWORK INFRASTRUCTURE (For Web Link Access)
# ------------------------------------------------------------------------------

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "threat-composer-igw"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true # Public subnets automatically assign public IPs

  tags = {
    Name = "threat-composer-public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "threat-composer-public-subnet-b"
  }
}

# ------------------------------------------------------------------------------
# 6. PUBLIC ROUTE TABLE
# ------------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # This route directs all outbound traffic to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "threat-composer-public-rt"
  }
}

resource "aws_route_table_association" "public_a" { #link public subnet A to the public route table
  subnet_id      = aws_subnet.network["public-a"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" { #link public subnet B to the public route table
  subnet_id      = aws_subnet.network["public-b"].id
  route_table_id = aws_route_table.public.id
}