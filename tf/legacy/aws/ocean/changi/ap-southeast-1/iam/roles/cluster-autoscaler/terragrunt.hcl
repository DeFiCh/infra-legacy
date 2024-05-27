include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/iam/roles/cluster-autoscaler.hcl"
}
