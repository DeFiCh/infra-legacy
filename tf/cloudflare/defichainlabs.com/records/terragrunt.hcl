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
    "email" = {
      allow_overwrite = true
      proxied         = false
      name            = "defichainlabs.com"
      value           = "smtp.google.com"
      type            = "MX"
      ttl             = 1
      tags            = [] # Unable in free version
      priority        = 1
      comment         = "For google workspace domain alias"
    }
  }
}
