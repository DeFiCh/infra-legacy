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

  zone_id         = var.zone_id
  name            = each.value.hostname
  value           = cloudflare_tunnel.this.cname
  type            = "CNAME"
  allow_overwrite = true
  proxied         = true
  comment         = "Zero Trust Tunnel - ${var.name}"
}

# Creates the configuration for the tunnel.
resource "cloudflare_tunnel_config" "this" {
  tunnel_id  = cloudflare_tunnel.this.id
  account_id = data.cloudflare_accounts.this.accounts[0].id

  config {
    # Ingress Rules 
    dynamic "ingress_rule" {
      for_each = var.ingress_rules
      content {
        hostname = cloudflare_record.this[ingress_rule.key].hostname
        service  = ingress_rule.value.service
        path     = ingress_rule.value.path
      }
    }

    # Catch unknown urls
    ingress_rule {
      service = "http_status:404"
    }
  }
}
