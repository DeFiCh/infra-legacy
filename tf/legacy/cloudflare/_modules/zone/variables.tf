variable "zone" {
  type        = string
  description = "DNS Zone name"
}

variable "jump_start" {
  type        = bool
  description = "Whether to scan DNS records on creation"
  default     = false
}

variable "plan" {
  type        = string
  description = "Commercial plan to use with the zone"
  default     = "free"
}
