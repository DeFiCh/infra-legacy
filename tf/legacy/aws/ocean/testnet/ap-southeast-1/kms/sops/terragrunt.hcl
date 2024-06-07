include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/kms/common.hcl"
}

inputs = {
  name        = "sops"
  description = "KMS key for ${dependency.labels.outputs.id} SOPS"
}
