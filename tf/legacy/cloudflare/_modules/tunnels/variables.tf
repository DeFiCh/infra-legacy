variable "name" {
  type        = string
  description = "Name for tunnel"
}

variable "ingress_rules" {
  type = map(object({
    hostname = string
    service  = string
    zone_id  = string
    path     = optional(string)
  }))
}
