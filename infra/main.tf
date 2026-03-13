module "vpc" {
    source = "./modules/vpc"
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
    az       = var.az
}