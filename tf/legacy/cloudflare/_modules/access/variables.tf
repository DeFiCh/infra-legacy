variable "access_groups" {
  type        = map(list(string))
  default     = {}
  description = "Map config of Google groups"
}

variable "applications" {
  type = map(object({
    domain           = string
    session_duration = optional(string, "24h")
    groups           = optional(list(string), [])
    logo_url         = optional(string)
  }))
  default     = {}
  description = "Map config of Applications"
}
