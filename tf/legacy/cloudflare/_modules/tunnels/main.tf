# Generates a 64-character secret for the tunnel.
# Using `random_password` means the result is treated as sensitive and, thus,
# not displayed in console output. Refer to: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "this" {
  length = 64
}

# Creates a new locally-managed tunnel for the GCP VM.
resource "cloudflare_tunnel" "this" {
  name       = var.name
  account_id = data.cloudflare_accounts.this.accounts[0].id
  secret     = base64sha256(random_password.this.result)
}

# Creates the CNAME record that routes http_app.${var.cloudflare_zone} to the tunnel.
resource "cloudflare_record" "this" {
  for_each = var.ingress_rules

  zone_id = var.zone_id
  name    = each.value.hostname
  value   = cloudflare_tunnel.this.cname
  type    = "CNAME"
  proxied = true
}

# Creates the configuration for the tunnel.
resource "cloudflare_tunnel_config" "this" {
  tunnel_id  = cloudflare_tunnel.this.id
  account_id = data.cloudflare_accounts.this.accounts[0].id

  config {
    # warp_routing {
    #   enabled = true
    # }

    # Ingress Rules 
    dynamic "ingress_rule" {
      for_each = var.ingress_rules
      content {
        hostname = cloudflare_record.this[ingress_rule.key].hostname
        service  = ingress_rule.value.service
      }
    }

    # Catch unknown urls
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Creates an Access application to control who can connect.
# resource "cloudflare_access_application" "http_app" {
#   zone_id          = var.cloudflare_zone_id
#   name             = "Access application for http_app.${var.cloudflare_zone}"
#   domain           = "http_app.${var.cloudflare_zone}"
#   session_duration = "1h"
# }

# # Creates an Access policy for the application.
# resource "cloudflare_access_policy" "http_policy" {
#   application_id = cloudflare_access_application.http_app.id
#   zone_id        = var.cloudflare_zone_id
#   name           = "Example policy for http_app.${var.cloudflare_zone}"
#   precedence     = "1"
#   decision       = "allow"
#   include {
#     email = [var.cloudflare_email]
#   }
# }
