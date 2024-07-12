include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/applications"
}

dependency "access" {
  config_path = "${dirname(find_in_parent_folders("provider.hcl"))}/zero-trust/access"
}

inputs = {
  applications = {
    "[Mainnet] Grafana" = {
      domain   = "grafana.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://upload.wikimedia.org/wikipedia/commons/a/a1/Grafana_logo.svg"
      policies = [
        dependency.access.outputs.policies["engineering-access"].id
      ]
      tags = [
        dependency.access.outputs.tags["mainnet"].id,
        dependency.access.outputs.tags["internal"].id
      ]
    }
    "[Mainnet] Rancher" = {
      domain   = "rancher.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://www.rancher.com/assets/img/logos/rancher-suse-logo-stacked-color.svg"
      policies = [
        dependency.access.outputs.policies["engineering-access"].id
      ]
      tags = [
        dependency.access.outputs.tags["mainnet"].id,
        dependency.access.outputs.tags["internal"].id
      ]
    }
    "[Mainnet] ArgoCD" = {
      domain   = "argo.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://icon.icepanel.io/Technology/svg/Argo-CD.svg"
      policies = [
        dependency.access.outputs.policies["engineering-access"].id
      ]
      tags = [
        dependency.access.outputs.tags["mainnet"].id,
        dependency.access.outputs.tags["internal"].id
      ]
    }
    "[Mainnet] ArgoCD - Badge Bypass" = {
      domain               = "argo.mainnet.ocean.jellyfishsdk.com/api/badge"
      decision             = "bypass"
      logo_url             = "https://icon.icepanel.io/Technology/svg/Argo-CD.svg"
      app_launcher_visible = false
      policies = [
        dependency.access.outputs.policies["public-access"].id
      ]
      tags = [
        dependency.access.outputs.tags["mainnet"].id,
        dependency.access.outputs.tags["public"].id
      ]
    }
    "[Mainnet] Prometheus" = {
      domain   = "prometheus.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://upload.wikimedia.org/wikipedia/commons/3/38/Prometheus_software_logo.svg"
      policies = [
        dependency.access.outputs.policies["engineering-access"].id
      ]
      tags = [
        dependency.access.outputs.tags["mainnet"].id,
        dependency.access.outputs.tags["internal"].id
      ]
    }
    "[Mainnet] Blockscout" = {
      domain   = "blockscout.mainnet.ocean.jellyfishsdk.com"
      decision = "bypass"
      logo_url = "https://pbs.twimg.com/profile_images/1563254263161032704/1RBJKVcR_400x400.jpg"
      policies = [
        dependency.access.outputs.policies["public-access"].id
      ]
      tags = [
        dependency.access.outputs.tags["mainnet"].id,
        dependency.access.outputs.tags["public"].id
      ]
    }
  }
}
