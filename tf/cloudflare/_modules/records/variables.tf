variable "zone_id" {
  type        = string
  description = "Cloudflare zone id"
}

variable "records" {
  type = map(object({
    allow_overwrite = bool
    proxied         = bool
    name            = string
    value           = string
    type            = string
    ttl             = number
    tags            = list(string)
    comment         = string
    priority        = number
  }))
  description = "DNS Records mapping"
}
