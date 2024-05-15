include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

terraform {
  source = "${dirname(find_in_parent_folders("provider.hcl"))}/_modules/zone"
}

inputs = {
  zone       = "defichainlabs.com"
  jump_start = false
  plan       = "free"
}
