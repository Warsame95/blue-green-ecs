module "vpc" {
    source = "./modules/vpc"
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
    az       = var.az
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  app_name            = var.app_name
}

module "dns" {
  source   = "./modules/dns"
  dns_name = module.alb.dns_name
  zone_id  = module.alb.zone_id
  domain   = var.domain
}