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

  create_security_group = true
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
    }
  }

  # Remove Name as it's conflicting with the tags generated in module
  tags = { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" }
}
