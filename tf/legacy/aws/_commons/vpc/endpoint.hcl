dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//modules/vpc-endpoints//.?version=5.8.1"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  # Remove Name as it's conflicting with the tags generated in module
  tags = { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" }
}
