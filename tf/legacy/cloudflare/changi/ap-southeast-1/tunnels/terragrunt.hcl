include "provider" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/tunnels"
}

dependency "zone" {
  config_path = "${dirname(find_in_parent_folders("provider.hcl"))}/sites/jellyfishsdk.com/zone"
}

inputs = {
  zone_id = dependency.zone.outputs.id
  name    = "${include.provider.locals.label_id}-${include.provider.locals.region_abbreviation}"
  ingress_rules = {
    "argo.changi.ocean" = {
      hostname = "argo.changi.ocean"
      service  = "http://argo-cd-server.argo.svc.cluster.local"
    }
  }
}
