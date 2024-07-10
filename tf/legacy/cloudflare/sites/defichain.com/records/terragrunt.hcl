
locals {
  domain = "defichain.com"
  email_defaults = {
    allow_overwrite = true
    proxied         = false
    name            = "defichain.com"
    type            = "MX"
    ttl             = 1
    tags            = []
    comment         = "For google workspace smtp"
  }
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
        comment         = "Main Site"
      }
      "ses-1" = {
        allow_overwrite = true
        proxied         = false
        name            = "xy43uebnmaeklpm2fn6mrxzbhg77h2if._domainkey.${local.domain}"
        value           = "xy43uebnmaeklpm2fn6mrxzbhg77h2if.dkim.amazonses.com"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "AWS SES 1"
      }
      "ses-2" = {
        allow_overwrite = true
        proxied         = false
        name            = "x2v23cqqnaazmqdfa2odbb4azbysnibr._domainkey.${local.domain}"
        value           = "x2v23cqqnaazmqdfa2odbb4azbysnibr.dkim.amazonses.com"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "AWS SES 2"
      }
      "blog" = {
        allow_overwrite = true
        proxied         = false
        name            = "blog.${local.domain}"
        value           = "defichain.ghost.io"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Defichain Blog"
      }
      "dex" = {
        allow_overwrite = true
        proxied         = false
        name            = "dex.${local.domain}"
        value           = "d303lberhl3dye.cloudfront.net"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Defichain Dex Explorer"
      }
      "snapshots" = {
        allow_overwrite = true
        proxied         = false
        name            = "snapshots.${local.domain}"
        value           = "d2wzbjljyk6wlg.cloudfront.net"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Defichain Snapshots"
      }
      "seed" = {
        allow_overwrite = true
        proxied         = false
        name            = "seed.${local.domain}"
        value           = "seeds.defichain.com"
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
        comment         = "Defichain Seeds List"
      }
    },
    {
      # Seeds
      for idx, val in [
        { value = "47.128.188.238" },
        { value = "13.215.103.209" },
        { value = "54.179.167.156" },
        { value = "52.220.242.209" },
        { value = "52.76.145.177" },
        { value = "54.254.187.247" },
        { value = "18.194.135.128" },
        { value = "18.157.54.233" },
        { value = "3.126.93.127" },
        { value = "18.196.228.211" },
        { value = "3.222.62.237" },
        { value = "34.231.39.255" },
        { value = "23.22.193.22" },
        { value = "54.158.108.109" },
        { value = "52.7.90.110" },
        { value = "54.157.155.244" },
      ] : "seeds-${idx}" =>
      {
        name            = "seeds.${local.domain}",
        comment         = "Seeds value records",
        value           = val.value,
        allow_overwrite = true
        proxied         = false
        type            = "A"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
      }
    },
    {
      # ACM Validation
      for idx, val in [
        { name = "_efec29636920f22a8cdf8cf7afbb7db6.${local.domain}", value = "_d19454ff91e77a3d128557a2a1a92145.zdxcnfdgtt.acm-validations.aws" },
        { name = "_89ad0f70c84a2f1f625688a0ead9d92b.${local.domain}", value = "_6f9fc443d2e74aae6d380ae1ab13c431.wggjkglgrm.acm-validations.aws" },
        { name = "_933481b7d08853e3fad3dbcd0d6ae840.defichain.io.${local.domain}", value = "_3d51d0d6a0c5f58ea8565dbe89ec7285.zdxcnfdgtt.acm-validations.aws" },
        { name = "_c144ab12df8b7feb4346579f51b000ba.ocean.${local.domain}", value = "_29bd1e8782da1c155ac1939d83bebfae.xrchbtpdjs.acm-validations.aws" },
        { name = "4dyw7vuayst3rjy5tsmopu7eaibhl3ca._domainkey.${local.domain}", value = "4dyw7vuayst3rjy5tsmopu7eaibhl3ca.dkim.amazonses.com" }
      ] : "validation-${idx}" =>
      {
        name            = val.name,
        comment         = "DNS Validation records",
        value           = val.value,
        allow_overwrite = true
        proxied         = false
        type            = "CNAME"
        ttl             = 300
        tags            = [] # Unable in free version
        priority        = null
      }
    },
    {
      # TXT Validation
      for idx, val in [
        { name = "${local.domain}", value = "v=spf1 a mx include:amazonses.com include:_spf.google.com include:spf.sendinblue.com -all" },
        { name = "${local.domain}", value = "google-site-verification=BheqBkatqJKP73oOuKqFlznnLDGjS7ZhJpJ-oRPupqA" },
        { name = "${local.domain}", value = "google-site-verification=OSP7yY7XJWRXMefxl0lecR6zPTK-4UKV-U_GfgPe3F4" },
        { name = "${local.domain}", value = "Sendinblue-code:96d7df493ec39fce2f30dbbe25c504fd" },
        { name = "${local.domain}", value = "brevo-code:1449d23c50e4035306b33a1b9172b777" },
        { name = "_dmarc.${local.domain}", value = "v=DMARC1; p=none; sp=none; rua=mailto:dmarc@mailinblue.com!10m; ruf=mailto:dmarc@mailinblue.com!10m; rf=afrf; pct=100; ri=86400" },
        { name = "_github-challenge-defich.www.${local.domain}", value = "f7964220ad" },
        { name = "_amazonses.${local.domain}", value = "+mtM6jVgENeCIdwoM1Wn56rVCKqe8g+X+h9PIs6XKFI=" },
      ] : "txt-${idx}" =>
      {
        name            = val.name,
        comment         = "TXT Validation records",
        value           = val.value,
        allow_overwrite = true
        proxied         = false
        type            = "TXT"
        ttl             = 300
        tags            = [] # Unable in free version
        priority        = null
      }
    },
    {
      # Netlify
      for idx, val in [
        { name = "zht" },
        { name = "zhs" },
        { name = "zh" },
        { name = "www" },
        { name = "web.wallet" },
        { name = "wallet" },
        { name = "testnet" },
        { name = "mainnet" },
        { name = "jellyfish" },
        { name = "explorer" },
        { name = "api.dex" },
      ] : "netlify-${idx}" =>
      {
        name            = "${val.name}.${local.domain}",
        comment         = "Netlify CNAME records",
        value           = "birthday.netlifyglobalcdn.com",
        allow_overwrite = true
        proxied         = false
        type            = "CNAME"
        ttl             = 1800
        tags            = [] # Unable in free version
        priority        = null
      }
    },
    {
      # Playground
      for idx, val in [
        { value = "ns-664.awsdns-19.net" },
        { value = "ns-1821.awsdns-35.co.uk" },
        { value = "ns-449.awsdns-56.com" },
        { value = "ns-1261.awsdns-29.org" },
        ] : "playground-${idx}" => merge(local.nameserver_defaults, {
          name    = "playground.${local.domain}",
          comment = "Playground DNS records",
          value   = val.value,
      })
    },
    {
      # Status
      for idx, val in [
        { value = "ns-1860.awsdns-40.co.uk" },
        { value = "ns-305.awsdns-38.com" },
        { value = "ns-1267.awsdns-30.org" },
        { value = "ns-841.awsdns-41.net" },
        ] : "status-${idx}" => merge(local.nameserver_defaults, {
          name    = "status.${local.domain}",
          comment = "Status DNS records",
          value   = val.value,
      })
    },
    {
      for idx, val in [
        { value = "aspmx.l.google.com", priority = 1 },
        { value = "alt1.aspmx.l.google.com", priority = 5 },
        { value = "alt2.aspmx.l.google.com", priority = 5 },
        { value = "aspmx2.googlemail.com", priority = 10 },
        { value = "aspmx3.googlemail.com", priority = 10 }
      ] : "email-${idx}" => merge(local.email_defaults, { value = val.value, priority = val.priority })
  })
}
