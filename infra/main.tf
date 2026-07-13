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
# Now, anywhere you need the URL, just use: module.ecr.repository_url

# module "ecs" {
#   source = "./modules/ecs"

#   # Pass the value from the ecr module into the variable expected by the ecs module
#   ecr_image_url = "${module.ecr.repository_url}" 
# }