terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}


# ==============================================================================
# SECURITY GROUPS (Firewalls)
# ==============================================================================

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for application load balancer"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    # Dynamically opens HTTP and HTTPS if a domain is provided, otherwise just HTTP
    for_each = var.domain_name != "" ? [var.http_port, var.https_port] : [var.http_port]
    content {
      description      = "Allow public traffic on port ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # trivy:ignore:AVD-AWS-0104
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# ==============================================================================
# APPLICATION LOAD BALANCER
# ==============================================================================

resource "aws_lb" "main" {
  name = "${var.project_name}-alb"

  # trivy:ignore:AVD-AWS-0053
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  # FIX: AWS-0052 Drop invalid headers
  drop_invalid_header_fields = true

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# ==============================================================================
# TARGET GROUP & HEALTH CHECKS
# ==============================================================================

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Required for Fargate tasks

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# ==============================================================================
# LISTENERS
# ==============================================================================

# trivy:ignore:AVD-AWS-0054
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.http_port
  protocol          = "HTTP"

  # Only define redirect if we have a domain
    default_action {
      type = var.domain_name != "" ? "redirect" : "forward"

      dynamic "default_action" {
        for_each = var.domain_name != "" ? [1] : []
        content {
          type = "redirect"
          redirect {
            port        = tostring(var.https_port)
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }
        }
      }

  dynamic "default_action" {
    for_each = var.domain_name == "" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.app.arn
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  count             = var.domain_name != "" ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "cloudflare_record" "tm_app" {
  zone_id = var.cloudflare_zone_id
  name    = "tm.umaratimomo"
  content = aws_lb.main.dns_name
  type    = "CNAME"
  proxied = false # Allows ACM cert to handle the HTTPS
}