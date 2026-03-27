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
  task_role_name = var.task_role_name
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
  
}

module "dynamodb" {
  source = "./modules/dynamodb"
  app_name = var.app_name

}

module "ecs" {
  source = "./modules/ecs"
  app_name = var.app_name
  region = var.region
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn = module.iam.task_role_arn
  container_image = var.container_image
  private_subnet_ids = module.vpc.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  vpc_id             = module.vpc.vpc_id
  alb_sg_id          = module.alb.alb_sg_id
}

module "vpc-endpoints" {
  source = "./modules/vpc-endpoints"
  vpc_id = module.vpc.vpc_id
  region = var.region
  private_subnet_ids = module.vpc.private_subnet_ids
  private_rtb_ids = module.vpc.private_rtb_ids
}
