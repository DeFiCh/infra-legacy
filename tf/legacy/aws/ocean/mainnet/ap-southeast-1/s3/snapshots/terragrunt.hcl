include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/s3/common.hcl"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

inputs = {
  bucket = "${dependency.labels.outputs.id}-snapshots"
  # acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }
}
