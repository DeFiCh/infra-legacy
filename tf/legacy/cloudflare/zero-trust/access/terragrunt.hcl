include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/access"
}

inputs = {
  # Define cloudflare groups mapped to google groups
  access_groups = {
    "devops"      = ["devops@defichain.com"]
    "engineering" = ["engineering@defichain.com"]
  }

  # Define access policies for cloudflare apps
  access_policies = {
    "engineering-access" = {
      includes = {
        "group" = {
          groups = ["devops", "engineering"]
        }
      }
    }
    "public-access" = {
      decision = "bypass"
      includes = {
        "everyone" = {
          everyone = true
        }
      }
    }
  }

  # Define tags to help filter applications
  access_tags = [
    "mainnet",
    "testnet",
    "changi",
    "internal",
    "public"
  ]
}
