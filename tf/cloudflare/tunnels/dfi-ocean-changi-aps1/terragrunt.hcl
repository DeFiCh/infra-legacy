include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/tunnels"
}

dependency "zone" {
  config_path = "${dirname(find_in_parent_folders("provider.hcl"))}/sites/defichainlabs.com/zone"
}

inputs = {
  zone_id = dependency.zone.outputs.id
  name    = basename(get_terragrunt_dir())
  ingress_rules = {
    "argo.changi" = {
      hostname = "argo.changi"
      service  = "http://argo-cd-server.argo.svc.cluster.local"
    }
  }
}
