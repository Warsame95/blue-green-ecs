resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnet_ids
  security_group_ids = [aws_security_group.endpoint-sg.id]
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnet_ids
  security_group_ids = [aws_security_group.endpoint-sg.id]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [var.private_rtb_id]
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [var.private_rtb_id]
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id = var.vpc_id
  vpc_endpoint_type = "Interface"
  service_name = "com.amazonaws.${var.region}.logs"
  subnet_ids = var.private_subnet_ids
  security_group_ids = [aws_security_group.endpoint-sg.id]
}

resource "aws_security_group" "endpoint-sg" {
  name        = "endpoint-sg"
  description = "Allows traffic coming from ecs"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443 
    security_groups = [ var.ecs_sg_id ]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
 
}
