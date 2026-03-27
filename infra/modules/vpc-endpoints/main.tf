resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id       = var.vpc_id
  region       = var.region
  service_name = "com.amazonaws.eu-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnet_ids
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id       = var.vpc_id
  region       = var.region
  service_name = "com.amazonaws.eu-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnet_ids
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  region       = var.region
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.eu-west-2.s3"
  route_table_ids = var.private_rtb_ids
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  region       = var.region
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.eu-west-2.dynamodb"
  route_table_ids = var.private_rtb_ids
}

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint_rtb_associations" {
  count = 2
  route_table_id  = var.private_rtb_ids[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_endpoint_rtb_associations" {
  count = 2
  route_table_id  = var.private_rtb_ids[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb
}
