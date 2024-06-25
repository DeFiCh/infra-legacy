resource "cloudflare_access_group" "this" {
  for_each = var.access_groups

  account_id = data.cloudflare_accounts.this.accounts[0].id
  name       = each.key

  include {
    gsuite {
      email                = each.value
      identity_provider_id = data.cloudflare_access_identity_provider.google.id
    }
  }
}

resource "cloudflare_access_policy" "this" {
  for_each = var.applications

  account_id = data.cloudflare_accounts.this.accounts[0].id
  name       = each.key
  decision   = "allow"

  include {
    group = each.value.groups
  }

  depends_on = [cloudflare_access_group.this]
}

resource "cloudflare_access_application" "staging_app" {
  for_each = var.applications

  account_id = data.cloudflare_accounts.this.accounts[0].id

  name                      = each.key
  domain                    = each.value.domain
  type                      = "self_hosted"
  session_duration          = each.value.session_duration
  auto_redirect_to_identity = true

  policies = [
    cloudflare_access_policy.this[each.key].id
  ]
}
