output "id" {
  description = "(String) The ID of this resource."
  value       = cloudflare_zone.this.id
}

output "meta" {
  description = "(Map of Boolean)"
  value       = cloudflare_zone.this.meta
}

output "name_servers" {
  description = "(List of String) Cloudflare-assigned name servers. This is only populated for zones that use Cloudflare DNS."
  value       = cloudflare_zone.this.name_servers
}

output "status" {
  description = "(String) Status of the zone. Available values: active, pending, initializing, moved, deleted, deactivated."
  value       = cloudflare_zone.this.status
}

output "vanity_name_servers" {
  description = "(List of String) List of Vanity Nameservers (if set)."
  value       = cloudflare_zone.this.vanity_name_servers
}

output "verification_key" {
  description = "(String) Contains the TXT record value to validate domain ownership. This is only populated for zones of type partial."
  value       = cloudflare_zone.this.verification_key
}
