dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///cloudposse/iam-role/aws//.?version=0.19.0"
}

dependency "eks" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/eks"
}

dependency "snapshot_bucket" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/s3/snapshots"
}

inputs = {
  name               = "snapshotter"
  policy_description = "Policy to allow snapshotter service to upload to bucket"
  role_description   = "IAM role to allow snapshotter service to upload to bucket"

  policy_documents = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ListObjectsInBucket",
          "Effect" : "Allow",
          "Action" : ["s3:ListBucket"],
          "Resource" : ["arn:aws:s3:::${dependency.snapshot_bucket.outputs.s3_bucket_id}"]
        },
        {
          "Sid" : "AllObjectActions",
          "Effect" : "Allow",
          "Action" : "s3:*Object*",
          "Resource" : ["arn:aws:s3:::${dependency.snapshot_bucket.outputs.s3_bucket_id}/*"]
        }
      ]
    })
  ]

  principals = {
    Federated = [dependency.eks.outputs.oidc_provider_arn]
  }

  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  assume_role_conditions = [
    {
      test     = "StringLike"
      variable = "${dependency.eks.outputs.oidc_provider}:sub"
      values   = ["system:serviceaccount:ocean:*"]
    }
  ]

  context = dependency.labels.outputs.context
}
