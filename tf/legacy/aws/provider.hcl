locals {
  env_vars            = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  account_vars        = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals
  region              = try(read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region, "ap-southeast-1")
  region_abbreviation = "${substr(split("-", local.region)[0], 0, 2)}${substr(split("-", local.region)[1], 0, 1)}${substr(split("-", local.region)[2], 0, 1)}"

  labels = {
    namespace   = try(local.account_vars.namespace, "dfi")
    environment = local.env_vars.environment
    tenant      = local.account_vars.tenant
    attributes  = [local.region_abbreviation]
    tags = {
      ManagedBy = "terraform"
    }
    label_order = ["namespace", "tenant", "environment", "attributes", "name"]
  }

  label_id = "${local.labels.namespace}-${local.labels.tenant}-${local.labels.environment}"

  # Have to staticly define here due to cyclic dependency with labels module
  remote_state_name = "${local.label_id}-tfstate"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
        region = "${local.region}"
    }
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = local.remote_state_name
    key     = "aws/${trimprefix(path_relative_to_include(), "${local.labels.tenant}/")}/terraform.tfstate" # Trim until region level
    region  = "ap-southeast-1"                                                                             # one bucket per account
    encrypt = true
  }
}
