dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///cloudposse/ecr/aws//.?version=0.41.0"
}

inputs = {
  context = dependency.labels.outputs.context
}
