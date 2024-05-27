terraform {
  source = "tfr:///cloudposse/label/null//.?version=0.25.0"
}

# provider & backend
include "provider" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

inputs = merge(
  include.provider.locals.labels,
)
