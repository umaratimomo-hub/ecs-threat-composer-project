# 1. Request the Certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Automatically create the DNS records in Cloudflare
resource "cloudflare_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id

  # FIX 1: Strip the trailing dot AWS provides
  name = trimsuffix(each.value.name, ".")

  # FIX 2: Use 'content' for Cloudflare provider v4 (if on v3, change this back to 'value')
  content = each.value.record

  type    = each.value.type
  proxied = false # Must be false for AWS to read the validation record
  ttl     = 60
}

# 3. Tell Terraform to wait for AWS to validate the certificate
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in cloudflare_record.cert_validation : record.hostname]
}