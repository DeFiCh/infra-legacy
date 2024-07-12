variable "access_groups" {
  type        = map(list(string))
  default     = {}
  description = "Map config of Google groups"
}

variable "access_policies" {
  type = map(object({
    decision = optional(string, "allow")
    includes = map(object({
      groups                  = optional(list(string), [])
      everyone                = optional(bool)
      any_valid_service_token = optional(bool)
    }))
  }))
  default     = {}
  description = "Map of access policies for applications"
}

variable "access_tags" {
  type        = list(string)
  default     = []
  description = "List of tags to filter applications"
}
