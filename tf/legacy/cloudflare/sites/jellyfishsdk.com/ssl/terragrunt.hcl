include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/ssl"
}

dependency "zone" {
  config_path = "../zone"
}

inputs = {
  zone_id = dependency.zone.outputs.id
  certificate_packs = {
    "changi.ocean.jellyfishsdk.com" = {
      validation_method     = "txt"
      hosts                 = ["changi.ocean.jellyfishsdk.com", "*.changi.ocean.jellyfishsdk.com"]
      certificate_authority = "lets_encrypt"
    }
  }
}
