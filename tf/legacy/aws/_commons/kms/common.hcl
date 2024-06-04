dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///cloudposse/kms-key/aws//.?version=0.12.1"
}

inputs = {
  enable_key_rotation = true
  context             = dependency.labels.outputs.context
}
