variable "zone_id" {
  type        = string
  description = "Cloudflare zone id"
}

variable "certificate_packs" {
  type = map(object({
    validation_method     = optional(string, "txt") # txt, http, email
    hosts                 = list(string)
    validity_days         = optional(number, 90)
    certificate_authority = optional(string, "lets_encrypt") # digicert, lets_encrypt, google
  }))
  description = "Map of certificate packs to generate"
}
