
locals {
  email_defaults = {
    allow_overwrite = true
    proxied         = false
    name            = "defichain.com"
    type            = "MX"
    ttl             = 1
    tags            = []
    comment         = "For google workspace smtp"
  }
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/records"
}

dependency "zone" {
  config_path = "../zone"
}

inputs = {
  zone_id = dependency.zone.outputs.id
  records = {
    for idx, val in [
      { value = "aspmx.l.google.com", priority = 1 },
      { value = "alt1.aspmx.l.google.com", priority = 5 },
      { value = "alt2.aspmx.l.google.com", priority = 5 },
      { value = "aspmx2.googlemail.com", priority = 10 },
      { value = "aspmx3.googlemail.com", priority = 10 }
    ] : "email-${idx}" => merge(local.email_defaults, { value = val.value, priority = val.priority })
  }
}
