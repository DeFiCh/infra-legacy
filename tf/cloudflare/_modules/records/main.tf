# Add a record to the domain
resource "cloudflare_record" "this" {
  for_each = var.records
  zone_id  = var.zone_id

  name            = each.value.name
  value           = each.value.value
  type            = each.value.type
  ttl             = each.value.ttl
  allow_overwrite = each.value.allow_overwrite
  proxied         = each.value.proxied
  tags            = each.value.tags
  comment         = each.value.comment
  priority        = each.value.priority
}
