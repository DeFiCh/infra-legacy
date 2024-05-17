locals {
  domain = "jellyfishsdk.com"
  nameserver_defaults = {
    allow_overwrite = true
    proxied         = false
    priority        = null
    type            = "NS"
    ttl             = 1
    tags            = null
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
        tags            = null # Unable in free version
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
        tags            = null # Unable in free version
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
        tags            = null # Unable in free version
        priority        = null
        comment         = "Better uptime status page"
      }
    },
    {
      # Mainnet Jellyfishsdk.com
      for idx, val in [
        { value = "ns-1911.awsdns-46.co.uk" },
        { value = "ns-570.awsdns-07.net" },
        { value = "ns-1507.awsdns-60.org" },
        { value = "ns-387.awsdns-48.com" },
        ] : "mainnet-${idx}" => merge(local.nameserver_defaults, {
          name    = "mainnet.${local.domain}",
          comment = "Mainnet DNS records",
          value   = val.value,
      })
    },
    {
      # Testnet Jellyfishsdk.com
      for idx, val in [
        { value = "ns-1019.awsdns-63.net" },
        { value = "ns-1857.awsdns-40.co.uk" },
        { value = "ns-1068.awsdns-05.org" },
        { value = "ns-323.awsdns-40.com" },
        ] : "testnet-${idx}" => merge(local.nameserver_defaults, {
          name    = "testnet.${local.domain}",
          comment = "Testnet DNS records",
          value   = val.value,
      })
    },
    {
      # Changi Jellyfishsdk.com
      for idx, val in [
        { value = "ns-1305.awsdns-35.org" },
        { value = "ns-774.awsdns-32.net" },
        { value = "ns-1693.awsdns-19.co.uk" },
        { value = "ns-169.awsdns-21.com" },
        ] : "changi-${idx}" => merge(local.nameserver_defaults, {
          name    = "changi.${local.domain}",
          comment = "Changi DNS records",
          value   = val.value,
      })
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
