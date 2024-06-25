locals {
  domain = "mainnet.ocean"
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
  zone_id = dependency.zone.outputs.id
  name    = "${include.provider.locals.label_id}-${include.provider.locals.region_abbreviation}"
  ingress_rules = {
    # "0" = {
    #   hostname = "${local.domain}"
    #   service  = "http://whale.ocean.svc.cluster.local:3000"
    # }
    "1" = {
      hostname = "eth.${local.domain}"
      service  = "http://defid.ocean.svc.cluster.local:8551"
    }
    "2" = {
      hostname = "blockscout.${local.domain}"
      path     = "api"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
    }
    "3" = {
      hostname = "blockscout.${local.domain}"
      path     = "verify_smart_contract"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
    }
    "4" = {
      hostname = "blockscout.${local.domain}"
      path     = "socket"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
    }
    "5" = {
      hostname = "blockscout.${local.domain}"
      service  = "http://frontend.blockscout.svc.cluster.local:3000"
    }
    "6" = {
      hostname = "visualizer.${local.domain}"
      service  = "http://visualizer.blockscout.svc.cluster.local:8050"
    }
    "7" = {
      hostname = "stats.${local.domain}"
      service  = "http://stats.blockscout.svc.cluster.local:80"
    }
    "8" = {
      hostname = "argo.${local.domain}"
      service  = "http://argo-cd-server.argo.svc.cluster.local"
    }
    "9" = {
      hostname = "grafana.${local.domain}"
      service  = "http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local"
    }
  }
}
