variable "domain_name" {
  type        = string
  description = "The root domain name (e.g., example.com)"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token for DNS validation"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The Zone ID from Cloudflare"
}