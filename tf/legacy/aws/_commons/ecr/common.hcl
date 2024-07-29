dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///terraform-aws-modules/ecr/aws//.?version=2.2.1"
}

inputs = {
  tags = dependency.labels.outputs.tags
}
