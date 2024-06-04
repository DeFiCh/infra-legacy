dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws//.?version=4.1.2"
}

inputs = {
  bucket = dependency.labels.outputs.id
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  # Remove Name as it's conflicting with the tags generated in module
  tags = { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" }
}
