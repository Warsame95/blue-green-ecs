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
  alb_zone_id  = module.alb.alb_zone_id
  domain   = var.domain
}

module "acm" {
  source = "./modules/acm"
  domain = var.domain
  app_name = var.app_name
  zone_id = module.dns.zone_id
}

module "waf" {
  source = "./modules/waf"
  app_name = var.app_name
  alb_arn = module.alb.alb_arn
}

module "iam" {
  source               = "./modules/iam"
  execution_role_name  = var.execution_role_name
  execution_policy_arn = var.execution_policy_arn
  
}
