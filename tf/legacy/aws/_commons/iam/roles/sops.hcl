dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

dependency "eks" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/eks"
}

dependency "kms" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/kms/sops"
}

terraform {
  source = "tfr:///cloudposse/iam-role/aws//.?version=0.19.0"
}


inputs = {
  name               = "sops"
  policy_description = "Policy to allow SOPS decryption"
  role_description   = "IAM role to allow SOPS decryption"

  policy_documents = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "kms:DescribeKey",
            "kms:Decrypt"
          ],
          "Effect" : "Allow",
          "Resource" : "${dependency.kms.outputs.key_arn}",
          "Sid" : "Decrypt"
        }
      ],
    })
  ]

  principals = {
    Federated = [dependency.eks.outputs.oidc_provider_arn]
  }

  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]

  context = dependency.labels.outputs.context
}
