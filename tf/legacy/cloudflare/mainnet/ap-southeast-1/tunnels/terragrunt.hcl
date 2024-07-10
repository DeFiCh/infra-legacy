locals {
  domain = "ocean"
}

include "provider" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/tunnels"
}

dependency "jellyfishsdk" {
  config_path = "${dirname(find_in_parent_folders("provider.hcl"))}/sites/jellyfishsdk.com/zone"
}

dependency "defichain" {
  config_path = "${dirname(find_in_parent_folders("provider.hcl"))}/sites/defichain.com/zone"
}

inputs = {
  name = "${include.provider.locals.label_id}-${include.provider.locals.region_abbreviation}"
  ingress_rules = {
    # Jellyfishsdk
    "0" = {
      hostname = "mainnet.${local.domain}"
      service  = "http://whale.ocean.svc.cluster.local:3000"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "1" = {
      hostname = "eth.mainnet.${local.domain}"
      service  = "http://defid.ocean.svc.cluster.local:8551"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "2" = {
      hostname = "blockscout.mainnet.${local.domain}"
      path     = "api"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "3" = {
      hostname = "blockscout.mainnet.${local.domain}"
      path     = "verify_smart_contract"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "4" = {
      hostname = "blockscout.mainnet.${local.domain}"
      path     = "socket"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "5" = {
      hostname = "blockscout.mainnet.${local.domain}"
      service  = "http://frontend.blockscout.svc.cluster.local:3000"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "6" = {
      hostname = "visualizer.mainnet.${local.domain}"
      service  = "http://visualizer.blockscout.svc.cluster.local:8050"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "7" = {
      hostname = "stats.mainnet.${local.domain}"
      service  = "http://stats.blockscout.svc.cluster.local:80"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "8" = {
      hostname = "argo.mainnet.${local.domain}"
      service  = "http://argo-cd-server.argo.svc.cluster.local"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "9" = {
      hostname = "grafana.mainnet.${local.domain}"
      service  = "http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "10" = {
      hostname = "rancher.mainnet.${local.domain}"
      service  = "http://rancher.cattle-system.svc.cluster.local"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "11" = {
      hostname = "api.mainnet.${local.domain}"
      service  = "http://legacy-stats.ocean.svc.cluster.local:3000"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    "12" = {
      hostname = "defid.mainnet.${local.domain}"
      service  = "http://defid.ocean.svc.cluster.local:8554"
      zone_id  = dependency.jellyfishsdk.outputs.id
    }
    # Defichain
    "50" = {
      hostname = "${local.domain}"
      service  = "http://whale.ocean.svc.cluster.local:3000"
      zone_id  = dependency.defichain.outputs.id
    }
    "51" = {
      hostname = "eth.${local.domain}"
      service  = "http://defid.ocean.svc.cluster.local:8551"
      zone_id  = dependency.defichain.outputs.id
    }
    "52" = {
      hostname = "blockscout.${local.domain}"
      path     = "api"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.defichain.outputs.id
    }
    "53" = {
      hostname = "blockscout.${local.domain}"
      path     = "verify_smart_contract"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.defichain.outputs.id
    }
    "54" = {
      hostname = "blockscout.${local.domain}"
      path     = "socket"
      service  = "http://backend.blockscout.svc.cluster.local:4000"
      zone_id  = dependency.defichain.outputs.id
    }
    "55" = {
      hostname = "blockscout.${local.domain}"
      service  = "http://frontend.blockscout.svc.cluster.local:3000"
      zone_id  = dependency.defichain.outputs.id
    }
    "56" = {
      hostname = "visualizer.${local.domain}"
      service  = "http://visualizer.blockscout.svc.cluster.local:8050"
      zone_id  = dependency.defichain.outputs.id
    }
    "57" = {
      hostname = "stats.${local.domain}"
      service  = "http://stats.blockscout.svc.cluster.local:80"
      zone_id  = dependency.defichain.outputs.id
    }
    "58" = {
      hostname = "api.${local.domain}"
      service  = "http://legacy-stats.ocean.svc.cluster.local:3000"
      zone_id  = dependency.defichain.outputs.id
    }
    "59" = {
      hostname = "api"
      service  = "http://legacy-stats.ocean.svc.cluster.local:3000"
      zone_id  = dependency.defichain.outputs.id
    }
    "60" = {
      hostname = "defid.${local.domain}"
      service  = "http://defid.ocean.svc.cluster.local:8554"
      zone_id  = dependency.defichain.outputs.id
    }
  }
}
