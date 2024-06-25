include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/access"
}

inputs = {
  access_groups = {
    "devops" = ["devops@defichain.com"]
  }
  applications = {
    "Mainnet Grafana" = {
      domain = "grafana.mainnet.ocean.jellyfishsdk.com"
      groups = ["devops"]
    }
  }
}
