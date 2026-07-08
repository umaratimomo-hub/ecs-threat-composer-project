module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.0.0.0/16"
  project_name = var.project_name
}

# module "ecr" {
#   source       = "./modules/ecr"
#   project_name = var.project_name
# }

# module "alb" {
#   source       = "./modules/alb"
#   project_name = var.project_name
# }

# module "ecs" {
#   source       = "./modules/ecs"
#   project_name = var.project_name
# }




# ------------------------------------------------------------------------------
# 9. VPC ENDPOINTS (The Private AWS Hallways)
# ------------------------------------------------------------------------------

data "aws_region" "current" {}

# S3 Gateway Endpoint (FREE)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.vpc.private_route_table_id]
}

# ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
}

# ECR DKR (REQUIRED FOR IMAGE PULL)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
}

# CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
}

# ECS Agent & Telemetry
resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
}

# ECS API
resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
}

# ------------------------------------------------------------------------------
# 10. ECS CLUSTER & LOGGING
# ------------------------------------------------------------------------------

resource "aws_ecs_cluster" "main" {
  name = "threat-composer-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/threat-composer"
  retention_in_days = 7 # Automatically purges old logs to keep costs at zero
}

# ------------------------------------------------------------------------------
# 11. IAM ROLES (Fargate Permissions)
# ------------------------------------------------------------------------------

# Execution Role: Gives the AWS Fargate Agent permission to pull from ECR and write to CloudWatch
resource "aws_iam_role" "ecs_execution_role" {
  name = "threat-composer-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task Role: Gives the actual containers inside the pod permissions to talk to other AWS services if needed
resource "aws_iam_role" "ecs_task_role" {
  name = "threat-composer-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })
}

# ------------------------------------------------------------------------------
# 12. ECS TASK DEFINITION (The Container Blueprint)
# ------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "app" {
  family                   = "threat-composer"
  network_mode             = "awsvpc" # REQUIRED for Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU (Lowest tier = lowest cost)
  memory                   = "512" # 512MB RAM
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "threat-composer"
      image     = "526644151787.dkr.ecr.eu-north-1.amazonaws.com/threat-composer:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = data.aws_region.current.region
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])
}

# ------------------------------------------------------------------------------
# 13. ECS SERVICE (The Orchestrator)
# ------------------------------------------------------------------------------

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  health_check_grace_period_seconds = 120

  network_configuration {
    subnets          = module.vpc.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "threat-composer"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.http]
}

# # ------------------------------------------------------------------------------
# # 14. ECR CONTAINER REGISTRY (Your Private Image Locker)
# # ------------------------------------------------------------------------------

# resource "aws_ecr_repository" "app" {
#   name                 = "threat-composer"
#   image_tag_mutability = "MUTABLE"
#   force_delete         = true

#   # This forces AWS to automatically scan your Docker images for known 
#   # security vulnerabilities every single time you push a new build.
#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = {
#     Name = "threat-composer-ecr"
#   }
# }

