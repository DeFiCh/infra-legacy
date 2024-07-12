resource "cloudflare_access_application" "this" {
  for_each = var.applications

  account_id = data.cloudflare_accounts.this.accounts[0].id

  name                 = each.key
  domain               = each.value.domain
  type                 = "self_hosted"
  session_duration     = each.value.session_duration
  logo_url             = each.value.logo_url
  app_launcher_visible = each.value.app_launcher_visible
  policies             = each.value.policies
  tags                 = each.value.tags
}
