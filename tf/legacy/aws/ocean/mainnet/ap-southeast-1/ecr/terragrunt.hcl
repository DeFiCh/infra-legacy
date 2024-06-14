include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/ecr/common.hcl"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

inputs = {
  image_names = ["argocd"]
}
