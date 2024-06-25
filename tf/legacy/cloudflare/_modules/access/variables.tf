variable "access_groups" {
  type        = map(list(string))
  default     = {}
  description = "Map config of Google groups"
}

variable "applications" {
  type = map(object({
    domain               = string
    decision             = optional(string, "allow")
    session_duration     = optional(string, "24h")
    logo_url             = optional(string)
    app_launcher_visible = optional(bool, true)
    includes = map(object({
      groups                  = optional(list(string), [])
      everyone                = optional(bool)
      any_valid_service_token = optional(bool)
    }))
  }))
  default     = {}
  description = "Map config of Applications"
}
