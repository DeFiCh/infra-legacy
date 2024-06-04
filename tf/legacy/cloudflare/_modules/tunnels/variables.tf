variable "name" {
  type        = string
  description = "Name for tunnel"
}

variable "zone_id" {
  type        = string
  description = "DNS Zone id to map tunnel to"
}

variable "ingress_rules" {
  type = map(object({
    hostname = string
    service  = string
    path     = optional(string)
  }))
}
