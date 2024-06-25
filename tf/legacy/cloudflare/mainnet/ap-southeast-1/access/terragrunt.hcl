include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/access"
}

dependency "tunnel" {
  config_path = "../tunnels"
}

inputs = {
  access_groups = {
    "devops"      = ["devops@defichain.com"]
    "engineering" = ["engineering@defichain.com"]
  }
  applications = {
    "[Mainnet] Grafana" = {
      domain   = "grafana.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://upload.wikimedia.org/wikipedia/commons/a/a1/Grafana_logo.svg"
      includes = {
        "group" = {
          groups = ["devops", "engineering"]
        }
      }
    }
    "[Mainnet] Rancher" = {
      domain   = "rancher.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://www.rancher.com/assets/img/logos/rancher-suse-logo-stacked-color.svg"
      includes = {
        "group" = {
          groups = ["devops", "engineering"]
        }
      }
    }
    "[Mainnet] ArgoCD" = {
      domain   = "argo.mainnet.ocean.jellyfishsdk.com"
      logo_url = "https://icon.icepanel.io/Technology/svg/Argo-CD.svg"
      includes = {
        "group" = {
          groups = ["devops", "engineering"]
        }
      }
    }
    "[Mainnet] ArgoCD - Badge Bypass" = {
      domain               = "argo.mainnet.ocean.jellyfishsdk.com/api/badge"
      decision             = "bypass"
      logo_url             = "https://icon.icepanel.io/Technology/svg/Argo-CD.svg"
      app_launcher_visible = false
      includes = {
        "everyone" = {
          everyone = true
        }
      }
    }
  }
}
