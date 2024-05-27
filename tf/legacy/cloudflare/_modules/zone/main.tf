resource "cloudflare_zone" "this" {
  account_id = data.cloudflare_accounts.this.accounts[0].id
  zone       = var.zone
  jump_start = var.jump_start
}
