locals {
  env_vars            = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  region              = try(read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region, "ap-southeast-1")
  region_abbreviation = "${substr(split("-", local.region)[0], 0, 2)}${substr(split("-", local.region)[1], 0, 1)}${substr(split("-", local.region)[2], 0, 1)}"

  labels = {
    namespace   = "dfi"
    environment = local.env_vars.environment
    tenant      = local.env_vars.account_name
    tags = {
      ManagedBy = "terraform"
    }
    label_order = ["namespace", "tenant", "environment", "name", "attributes"]
  }

  # Singapore will be default region
  label_id = "${local.labels.namespace}-${local.labels.tenant}-${local.labels.environment}"

  # Have to staticly define here due to cyclic dependency with labels module
  remote_state_name = "${local.label_id}-tfstate"
}

# Generate provider
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
        required_providers {
            cloudflare = {
                source  = "cloudflare/cloudflare"
                version = "~> 4.0"
            }
        }
    }

    provider "cloudflare" {}
  EOF
}

# Generate backend for remote state
remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = local.remote_state_name
    key     = "cloudflare/${trimprefix(path_relative_to_include(), "${local.labels.tenant}/")}/terraform.tfstate" # Trim until region level
    region  = "ap-southeast-1"                                                                                    # one bucket per account
    encrypt = true

    profile      = get_env("USE_AWS_PROFILE", "false") == "true" ? local.label_id : null
    role_arn     = get_env("USE_AWS_ROLE", "false") == "true" ? "arn:aws:iam::${local.env_vars.account_id}:role/${local.label_id}-terraform" : null
    session_name = get_env("USE_AWS_ROLE", "false") == "true" ? "${replace(path_relative_to_include(), "/", "-")}" : null
  }
}
