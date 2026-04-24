data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "foodie" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = format("%s-vpc", var.project_name)
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "foodie" {
  vpc_id = aws_vpc.foodie.id

  tags = {
    Name        = format("%s-igw", var.project_name)
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.foodie.id
  cidr_block              = cidrsubnet(aws_vpc.foodie.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = format("%s-public-%d", var.project_name, count.index + 1)
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.foodie.id

  route {
    cidr_block = var.public_route_cidr
    gateway_id = aws_internet_gateway.foodie.id
  }

  tags = {
    Name        = format("%s-public-rt", var.project_name)
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
