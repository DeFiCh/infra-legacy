resource "cloudflare_certificate_pack" "this" {
  for_each = var.certificate_packs

  zone_id                = var.zone_id
  type                   = "advanced"
  validation_method      = each.value.validation_method
  hosts                  = each.value.hosts
  validity_days          = each.value.validity_days
  certificate_authority  = each.value.certificate_authority
  cloudflare_branding    = false
  wait_for_active_status = true
}
