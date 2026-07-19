module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.0.0.0/16"
  project_name = var.project_name
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn    = module.acm.certificate_arn
  cloudflare_zone_id = var.cloudflare_zone_id
}

module "ecs" {
  source                 = "./modules/ecs"
  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  private_route_table_id = module.vpc.private_route_table_id
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
  repository_url         = module.ecr.repository_url
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "threat-composer-app"
  region          = "eu-north-1"
}

module "acm" {
  source               = "./modules/acm"
  domain_name          = var.domain_name
  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token
}