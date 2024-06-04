locals {
  domain = "jellyfishsdk.com"
  nameserver_defaults = {
    allow_overwrite = true
    proxied         = false
    priority        = null
    type            = "NS"
    ttl             = 1
    tags            = []
  }
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/records"
}

dependency "zone" {
  config_path = "../zone"
}

inputs = {
  zone_id = dependency.zone.outputs.id
  records = merge(
    {
      "web" = {
        allow_overwrite = true
        proxied         = false
        name            = local.domain
        value           = "147.75.40.150"
        type            = "A"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Jellyfishsdk Docusaurus"
      }
      "statuspage" = {
        allow_overwrite = true
        proxied         = false
        name            = "statuspage.${local.domain}"
        value           = "statuspage.betteruptime.com"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Better uptime status page"
      }
      "www" = {
        allow_overwrite = true
        proxied         = false
        name            = "www.${local.domain}"
        value           = "birthday.netlifyglobalcdn.com"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Better uptime status page"
      }
    },
    {
      # Mainnet Jellyfishsdk.com
      for idx, val in [
        { name = "mainnet.ocean.${local.domain}", value = "dualstack.cake-ocean-mainnet-whale-973680016.ap-southeast-1.elb.amazonaws.com" },
        { name = "eth.mainnet.ocean.${local.domain}", value = "dualstack.cake-ocean-mainnet-whale-973680016.ap-southeast-1.elb.amazonaws.com" },
        { name = "api.mainnet.ocean.${local.domain}", value = "dualstack.cake-ocean-mainnet-whale-973680016.ap-southeast-1.elb.amazonaws.com" },
        { name = "blockscout.mainnet.ocean.${local.domain}", value = "cake-ocean-mainnet-blockscout-1255397527.ap-southeast-1.elb.amazonaws.com" },
        { name = "stats.mainnet.ocean.${local.domain}", value = "cake-ocean-mainnet-blockscout-1255397527.ap-southeast-1.elb.amazonaws.com" },
        { name = "visualizer.mainnet.ocean.${local.domain}", value = "cake-ocean-mainnet-blockscout-1255397527.ap-southeast-1.elb.amazonaws.com" },
        { name = "defid.mainnet.ocean.${local.domain}", value = "ae6ea8d2ede66b9fc.awsglobalaccelerator.com" },
      ] :
      "${val.name}" => {
        allow_overwrite = true
        proxied         = false
        name            = val.name
        value           = val.value
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Mainnet Ocean + Blockscout"
      }
    },
    {
      # Testnet Jellyfishsdk.com
      for idx, val in [
        { name = "testnet.ocean.${local.domain}", value = "dualstack.cake-ocean-testnet-whale-87774044.ap-southeast-1.elb.amazonaws.com" },
        { name = "blockscout.testnet.ocean.${local.domain}", value = "dualstack.cake-ocean-testnet-blockscout-1420704679.ap-southeast-1.elb.amazonaws.com" },
        { name = "eth.testnet.ocean.${local.domain}", value = "dualstack.cake-ocean-testnet-whale-87774044.ap-southeast-1.elb.amazonaws.com" },
        { name = "stats.testnet.ocean.${local.domain}", value = "dualstack.cake-ocean-testnet-blockscout-1420704679.ap-southeast-1.elb.amazonaws.com" },
        { name = "visualizer.testnet.ocean.${local.domain}", value = "dualstack.cake-ocean-testnet-blockscout-1420704679.ap-southeast-1.elb.amazonaws.com" },
      ] :
      "${val.name}" => {
        allow_overwrite = true
        proxied         = false
        name            = val.name
        value           = val.value
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Testnet Ocean + Blockscout"
      }
    },
    {
      # Playground Jellyfishsdk.com
      for idx, val in [
        { value = "ns-1105.awsdns-10.org" },
        { value = "ns-1579.awsdns-05.co.uk" },
        { value = "ns-560.awsdns-06.net" },
        { value = "ns-469.awsdns-58.com" },
        ] : "playground-${idx}" => merge(local.nameserver_defaults, {
          name    = "playground.${local.domain}",
          comment = "Playground DNS records",
          value   = val.value,
      })
    },
    {
      # Status Jellyfishsdk.com
      for idx, val in [
        { value = "ns-72.awsdns-09.com" },
        { value = "ns-1058.awsdns-04.org" },
        { value = "ns-1789.awsdns-31.co.uk" },
        { value = "ns-706.awsdns-24.net" },
        ] : "status-${idx}" => merge(local.nameserver_defaults, {
          name    = "status.${local.domain}",
          comment = "status DNS records",
          value   = val.value,
      })
    },
  )
}
