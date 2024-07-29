include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/ecr/common.hcl"
}

include "provider" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

dependency "dockerhub_secret" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/secrets-manager/dockerhub"
}

dependency "github_secret" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/secrets-manager/github"
}

inputs = {
  create_repository = false

  # Registry Policy
  create_registry_policy = true
  registry_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Dockerhub"
        "Effect" : "Allow",
        "Action" : [
          "ecr:CreateRepository",
          "ecr:BatchImportUpstreamImage"
        ],
        "Principal" : {
          "AWS" : "arn:aws:iam::${include.provider.locals.account_vars.account_id}:root"
        },
        "Resource" : [
          "arn:aws:ecr-public::${include.provider.locals.account_vars.account_id}:repository/dockerhub/*",
          "arn:aws:ecr-public::${include.provider.locals.account_vars.account_id}:repository/github/*"
        ]
      }
    ]
  })

  # Registry Pull Through Cache Rules
  registry_pull_through_cache_rules = {
    pub = {
      ecr_repository_prefix = "ecr-public"
      upstream_registry_url = "public.ecr.aws"
    }
    dockerhub = {
      ecr_repository_prefix = "dockerhub"
      upstream_registry_url = "registry-1.docker.io"
      credential_arn        = dependency.dockerhub_secret.outputs.secret_arn
    }
    github = {
      ecr_repository_prefix = "github"
      upstream_registry_url = "ghcr.io"
      credential_arn        = dependency.github_secret.outputs.secret_arn
    }
    quay = {
      ecr_repository_prefix = "quay"
      upstream_registry_url = "quay.io"
    }
  }
}
