locals {
  org_id = "564950325795"
  billing_account_legacy_id = "01F606-D04835-3532AB" # Legacy
  billing_account_id = "01BA6B-33D914-55E186" # 2024-1

  root_folder_name = "dfi-labs"
  control_project_name = "${ local.root_folder_name }-control"
  control_state_bucket_name = "${ local.control_project_name }-state"
  control_service_account_name = "tf-control-sa"
  control_service_account_email = "${ local.control_service_account_name }@${ local.control_project_name }.iam.gserviceaccount.com"
  control_state_bucket_location      = "Asia"

  az = {
    asia = [{ region: "asia-southeast1", zone: "asia-southeast1-a" }],
    eu   = [{ region: "europe-west1", zone: "europe-west1-b" }],
    us   = [{ region: "us-central1", zone: "us-central1-a" }],
  }

  default_region = local.az.asia[0].region
  default_zone   = local.az.asia[0].zone
}

output org_id {
  value       = local.org_id
}

output billing_account_legacy_id {
    value       = local.billing_account_legacy_id
}

output billing_account_id {
    value       = local.billing_account_id
}

output root_folder_name {
    value       = local.root_folder_name
}

output control_project_name {
    value       = local.control_project_name
}

output control_state_bucket_name {
    value       = local.control_state_bucket_name
}

output control_service_account_name {
    value       = local.control_service_account_name
}

output control_service_account_email {
    value       = local.control_service_account_email
}

output control_state_bucket_location {
    value       = local.control_state_bucket_location
}

output az {
    value = local.az
}

output default_region {
    value = local.default_region
}

output default_zone {
    value = local.default_zone
}
