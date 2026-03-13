resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

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