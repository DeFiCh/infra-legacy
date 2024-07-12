locals {
  domain = "testnet.ocean"
}

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
  name = "${include.provider.locals.label_id}-${include.provider.locals.region_abbreviation}"
  ingress_rules = {
    "0" = {
      hostname = "${local.domain}"
      service  = "http://whale.ocean.svc.cluster.local:3000"
      zone_id  = dependency.zone.outputs.id
    }
    "1" = {
      hostname = "eth.${local.domain}"
      service  = "http://defid.ocean.svc.cluster.local:18551"
      zone_id  = dependency.zone.outputs.id
    }
    "2" = {
      hostname = "blockscout.${local.domain}"
      path     = "api"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.zone.outputs.id
    }
    "3" = {
      hostname = "blockscout.${local.domain}"
      path     = "verify_smart_contract"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.zone.outputs.id
    }
    "4" = {
      hostname = "blockscout.${local.domain}"
      path     = "socket"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.zone.outputs.id
    }
    "5" = {
      hostname = "blockscout.${local.domain}"
      service  = "http://frontend.blockscout.svc.cluster.local:3000"
      zone_id  = dependency.zone.outputs.id
    }
    "6" = {
      hostname = "visualizer.${local.domain}"
      service  = "http://visualizer.blockscout.svc.cluster.local:8050"
      zone_id  = dependency.zone.outputs.id
    }
    "7" = {
      hostname = "stats.${local.domain}"
      service  = "http://stats.blockscout.svc.cluster.local:80"
      zone_id  = dependency.zone.outputs.id
    }
    "8" = {
      hostname = "argo.${local.domain}"
      service  = "http://argo-cd-server.argo.svc.cluster.local"
      zone_id  = dependency.zone.outputs.id
    }
    "9" = {
      hostname = "grafana.${local.domain}"
      service  = "http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local"
      zone_id  = dependency.zone.outputs.id
    }
    "10" = {
      hostname = "rancher.${local.domain}"
      service  = "http://rancher.cattle-system.svc.cluster.local"
      zone_id  = dependency.zone.outputs.id
    }
  }
}
