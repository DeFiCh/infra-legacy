resource "cloudflare_zone" "this" {
  account_id = data.cloudflare_accounts.this.id
  zone       = var.zone
  jump_start = var.jump_start
}
