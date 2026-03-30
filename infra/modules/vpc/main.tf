resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
  }
  tags_all = {
    Name = var.vpc_name
  }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
    Name = "${var.vpc_name}-igw"
  }
  tags_all = {
    Name = "${var.vpc_name}-igw"
  }
    
}

resource "aws_subnet" "public" {
    count = 2
    vpc_id = aws_vpc.main.id
    availability_zone = var.az[count.index]
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index+1)

    tags = {
        Name = "${var.vpc_name}-public-${var.az[count.index]}"
    }
 }

resource "aws_subnet" "private" {
    count = 2
    vpc_id = aws_vpc.main.id
    availability_zone = var.az[count.index]
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index+101)

    tags = {
        Name = "${var.vpc_name}-private-${var.az[count.index]}"
    }

 }

 resource "aws_route_table" "public-rtb" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.vpc_name}-public-rtb"
    }
}

resource "aws_route_table" "private-rtb" {
    vpc_id = aws_vpc.main.id


    tags = {
            Name = "${var.vpc_name}-private-rtb"
        }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "private" {
  count = 2
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rtb.id
}