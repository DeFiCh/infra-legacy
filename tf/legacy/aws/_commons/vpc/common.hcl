dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//.?version=5.8.1"
}

inputs = {
  name = dependency.labels.outputs.id

  create_database_subnet_group    = false
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  map_public_ip_on_launch = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log                                 = false
  create_flow_log_cloudwatch_log_group            = false
  create_flow_log_cloudwatch_iam_role             = false
  flow_log_cloudwatch_log_group_class             = "INFREQUENT_ACCESS"
  flow_log_cloudwatch_log_group_retention_in_days = 180
  flow_log_max_aggregation_interval               = 600

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"                       = 1
    "kubernetes.io/cluster/${dependency.labels.outputs.id}" = "shared"
    "Tier"                                                  = "Private"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                                = 1
    "kubernetes.io/cluster/${dependency.labels.outputs.id}" = "shared"
    "Tier"                                                  = "Public"
  }

  # Remove Name as it's conflicting with the tags generated in module
  tags = { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" }
}
