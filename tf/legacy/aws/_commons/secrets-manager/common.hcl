dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///terraform-aws-modules/secrets-manager/aws//.?version=1.1.2"
}

inputs = {
  # Remove Name as it's conflicting with the tags generated in module
  tags = { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" }
}
