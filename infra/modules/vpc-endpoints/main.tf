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
  service_name = "com.amazonaws.eu-west-2.s3"
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  region       = var.region
  service_name = "com.amazonaws.eu-west-2.dynamodb"
}
