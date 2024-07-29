include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/secrets-manager/common.hcl"
}

include "provider" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

inputs = {
  # Secret names must contain 1-512 Unicode characters and be prefixed with ecr-pullthroughcache/
  name        = "ecr-pullthroughcache/${dependency.labels.outputs.id}"
  description = "Dockerhub credentials"

  recovery_window_in_days = 0
  ignore_secret_changes   = true
  secret_string = jsonencode({
    username    = "example"
    accessToken = "YouShouldNotStoreThisInPlainText"
  })

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${include.provider.locals.account_vars.account_id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }
}
