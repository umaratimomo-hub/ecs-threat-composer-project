# ------------------------------------------------------------------------------
# 0. DATA SOURCES
# ------------------------------------------------------------------------------

# This automatically gets the available AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# ------------------------------------------------------------------------------
# 1. CORE NETWORK (VPC)
# ------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

locals {
  subnets = {
    "public-a" = {
      # 10.0.0.0/16 + 8 bits, Network #1 -> 10.0.1.0/24
      cidr   = cidrsubnet(var.vpc_cidr, 8, 1)
      az     = data.aws_availability_zones.available.names[0]
      public = true
    }
    "public-b" = {
      # Network #2 -> 10.0.2.0/24
      cidr   = cidrsubnet(var.vpc_cidr, 8, 2)
      az     = data.aws_availability_zones.available.names[1]
      public = true
    }
    "private-a" = {
      # Network #10 -> 10.0.10.0/24
      cidr   = cidrsubnet(var.vpc_cidr, 8, 10)
      az     = data.aws_availability_zones.available.names[0]
      public = false
    }
    "private-b" = {
      # Network #11 -> 10.0.11.0/24
      cidr   = cidrsubnet(var.vpc_cidr, 8, 11)
      az     = data.aws_availability_zones.available.names[1]
      public = false
    }
  }
}

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

# ------------------------------------------------------------------------------
# 2. PRIVATE ROUTE TABLE & ASSOCIATIONS
# ------------------------------------------------------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rt"
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
# 3. INTERNET GATEWAY (For Web Access)
# ------------------------------------------------------------------------------

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# ------------------------------------------------------------------------------
# 4. PUBLIC ROUTE TABLE & ASSOCIATIONS
# ------------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.network["public-a"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.network["public-b"].id
  route_table_id = aws_route_table.public.id
}