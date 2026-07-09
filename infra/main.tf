module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.0.0.0/16"
  project_name = var.project_name
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "ecs-threat-composer-project"
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs" {
  source                 = "./modules/ecs"
  project_name           = "ecs-threat-composer-project"
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  private_route_table_id = module.vpc.private_route_table_id
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
}



moved {
  from = aws_ecs_cluster.main
  to   = module.ecs.aws_ecs_cluster.main
}

moved {
  from = aws_ecs_task_definition.app
  to   = module.ecs.aws_ecs_task_definition.app
}

moved {
  from = aws_ecs_service.app
  to   = module.ecs.aws_ecs_service.app
}

# Security Groups & Endpoints
moved {
  from = aws_security_group.ecs_tasks
  to   = module.ecs.aws_security_group.ecs_tasks
}
moved {
  from = aws_security_group.vpc_endpoints
  to   = module.ecs.aws_security_group.vpc_endpoints
}
moved {
  from = aws_vpc_endpoint.s3
  to   = module.ecs.aws_vpc_endpoint.s3
}
moved {
  from = aws_vpc_endpoint.ecr_api
  to   = module.ecs.aws_vpc_endpoint.ecr_api
}
moved {
  from = aws_vpc_endpoint.ecr_dkr
  to   = module.ecs.aws_vpc_endpoint.ecr_dkr
}
moved {
  from = aws_vpc_endpoint.logs
  to   = module.ecs.aws_vpc_endpoint.logs
}

# ECS & CloudWatch Core
moved {
  from = aws_cloudwatch_log_group.ecs
  to   = module.ecs.aws_cloudwatch_log_group.ecs
}
moved {
  from = aws_ecs_cluster.main
  to   = module.ecs.aws_ecs_cluster.main
}
moved {
  from = aws_ecs_task_definition.app
  to   = module.ecs.aws_ecs_task_definition.app
}
moved {
  from = aws_ecs_service.app
  to   = module.ecs.aws_ecs_service.app
}

# IAM Roles
moved {
  from = aws_iam_role.ecs_execution_role
  to   = module.ecs.aws_iam_role.ecs_execution_role
}
moved {
  from = aws_iam_role.ecs_task_role
  to   = module.ecs.aws_iam_role.ecs_task_role
}