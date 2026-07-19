terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# 1. Request the AWS ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name # e.g., "anaqahwear.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}",                  # Covers 1st level subdomains (e.g., tm.anaqahwear.com)
    "*.umaratimomo.${var.domain_name}"       # Covers 2nd level subdomains (e.g., tm.umaratimomo.anaqahwear.com)
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Create the DNS validation records in Cloudflare
# We map by 'dvo.resource_record_name' to prevent duplicate record conflicts.
resource "cloudflare_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.resource_record_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type
  proxied = false # Must be false (DNS-Only) for ACM validation to succeed
  ttl     = 60
}

# 3. Force Terraform to pause until the certificate is fully issued
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]
}