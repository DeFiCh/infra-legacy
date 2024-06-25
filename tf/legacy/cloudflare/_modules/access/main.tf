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
    group = [for idx, val in each.value.groups : cloudflare_access_group.this[val].id]
  }
}

resource "cloudflare_access_application" "this" {
  for_each = var.applications

  account_id = data.cloudflare_accounts.this.accounts[0].id

  name             = each.key
  domain           = each.value.domain
  type             = "self_hosted"
  session_duration = each.value.session_duration
  logo_url         = each.value.logo_url

  policies = [
    cloudflare_access_policy.this[each.key].id
  ]
}
