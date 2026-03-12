data "aws_caller_identity" "current" {}

data "aws_availability_zones" "az_available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name = "vpc-${var.environment}"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.subnet_public_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.az_available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "subnet-public-${var.environment}-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.subnet_private_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private_cidrs[count.index]
  availability_zone = data.aws_availability_zones.az_available.names[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "subnet-private-${var.environment}-${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "igw-${var.environment}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_public_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat-ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = merge(var.common_tags, {
    Name = "eip-nat-${var.environment}"
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.common_tags, {
    Name = "nat-gw-${var.environment}"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_private_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}