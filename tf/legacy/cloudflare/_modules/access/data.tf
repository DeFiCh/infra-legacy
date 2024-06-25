data "cloudflare_accounts" "this" {}

data "cloudflare_access_identity_provider" "google" {
  name       = "Google Workspace"
  account_id = data.cloudflare_accounts.this.accounts[0].id
}
