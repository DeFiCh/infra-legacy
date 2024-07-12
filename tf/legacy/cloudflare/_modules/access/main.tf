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
  for_each = var.access_policies

  account_id = data.cloudflare_accounts.this.accounts[0].id
  name       = each.key
  decision   = each.value.decision

  dynamic "include" {
    for_each = each.value.includes

    content {
      group                   = [for idx, val in include.value.groups : cloudflare_access_group.this[val].id]
      everyone                = include.value.everyone
      any_valid_service_token = include.value.any_valid_service_token
    }
  }
}

resource "cloudflare_access_tag" "this" {
  for_each = toset(var.access_tags)

  name       = each.value
  account_id = data.cloudflare_accounts.this.accounts[0].id
}
