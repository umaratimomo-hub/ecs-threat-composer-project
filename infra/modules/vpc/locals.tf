locals {
  subnets = {
    "public-a" = {
      cidr   = cidrsubnet(var.vpc_cidr, 8, 1)
      az     = data.aws_availability_zones.available.names[0]
      public = true
    }
    "public-b" = {
      cidr   = cidrsubnet(var.vpc_cidr, 8, 2)
      az     = data.aws_availability_zones.available.names[1]
      public = true
    }
    "private-a" = {
      cidr   = cidrsubnet(var.vpc_cidr, 8, 10)
      az     = data.aws_availability_zones.available.names[0]
      public = false
    }
    "private-b" = {
      cidr   = cidrsubnet(var.vpc_cidr, 8, 11)
      az     = data.aws_availability_zones.available.names[1]
      public = false
    }
  }
}