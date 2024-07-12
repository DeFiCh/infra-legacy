variable "applications" {
  type = map(object({
    domain               = string
    decision             = optional(string, "allow")
    session_duration     = optional(string, "24h")
    logo_url             = optional(string)
    app_launcher_visible = optional(bool, true)
    policies             = optional(list(string))
    tags                 = optional(list(string))
  }))
  default     = {}
  description = "Map config of Applications"
}
