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
  records = {
    "email" = {
      allow_overwrite = true
      proxied         = false
      name            = "defichainlabs.com"
      value           = "smtp.google.com"
      type            = "MX"
      ttl             = 1
      tags            = [] # Unable in free version
      priority        = 1
      comment         = "For google workspace domain alias"
    }
    "google-alias-verification" = {
      allow_overwrite = true
      proxied         = false
      name            = "defichainlabs.com"
      value           = "google-site-verification=tcIUrBPBc2lHpg5hVwNePmDZKRj23Tbu938A5PhQLSQ"
      type            = "TXT"
      ttl             = 1
      tags            = [] # Unable in free version
      priority        = 1
      comment         = "For google workspace domain alias verification"
    }
    "google-dkim" = {
      allow_overwrite = true
      proxied         = false
      name            = "google._domainkey"
      value           = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmlfP8eoY4I2r5kLfWkCL8SsdO1eDi0eohaIOqhzDnYXc1CBxW4XhX0fKEVE6i077yP+27Q1IhPxzq6MvzGOzyu3GHmy2vS2vgZWf4hxuPbyh6dT8rHiG2H2oHsLw5s4fSq/+MCyZGMM8jXTulq/q8VTLPX9Q9lIs4yVk5RFG1yPbSVz9pPcXV7fIq1um75xNQB9qthM+q+MM6aAzsykAp8yoSzQLdYqVvTvrn6QrF2W1250zIWmHnsbndGoOYYrDTHlAWeLmQBCNM0KQUxSZeg1Ve5jLqAeAtHMPbC70V903EXWIoMsxtPTkbLfMLuOqziNJw5dmzMZgeppIdCTQBwIDAQAB"
      type            = "TXT"
      ttl             = 1
      tags            = [] # Unable in free version
      priority        = 1
      comment         = "For google workspace domain DKIM"
    }
  }
}
