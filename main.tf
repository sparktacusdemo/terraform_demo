# ---Configure the AWS Provider
provider "aws" {
  region     = var.awsregion
  access_key = var.awsaccesskey
  secret_key = var.awssecretkey
}

#--- 1 vpc
resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.tags
  }
}

#--- 1 bridge Internet Gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id    = aws_vpc.myvpc.id

  tags      = {
    Name = "internet_gw"
  }
}

# --- elastic ips for A & B, & C
# ---3 NAT bridge (1 for each zones A, B, C) 
resource "aws_eip" "nat" {
  count     = length(var.public_subnet_cidr_blocks)
  vpc       = true
}

resource "aws_nat_gateway" "gw" {
  depends_on        = [aws_internet_gateway.gw] //resource "aws_internet_gateway.gw" will be created before it
  count             = length(var.public_subnet_cidr_blocks)
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = aws_subnet.public[count.index].id
}



# ----subnetworks (3 public, 3 private): 6 subnets to configure
resource "aws_subnet" "public" {
  count             = length(var.av_zones)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.av_zones[count.index]
}

resource "aws_subnet" "private" {
  count             = length(var.av_zones)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.av_zones[count.index]
}


# ---6 route tables to create
#---3 private route tables (1 per zone A/B/C)
resource "aws_route_table" "private" {
  count     = length(var.private_subnet_cidr_blocks)
  vpc_id    = aws_vpc.myvpc.id
}
resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)
  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.gw[count.index].id
}

#---3 public route tables (1 per zone A/B/C)
resource "aws_route_table" "public" {
  count     = length(var.public_subnet_cidr_blocks)
  vpc_id    = aws_vpc.myvpc.id
}
resource "aws_route" "public" {
  count                     = length(var.public_subnet_cidr_blocks)
  route_table_id            = aws_route_table.public[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
}



