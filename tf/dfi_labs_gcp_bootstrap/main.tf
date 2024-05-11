provider "google" {}

module gcp_default {
  source = "../modules/gcp_default_dfi_labs"
}

module gcp_bootstrap {
  source = "../modules/gcp_bootstrap"
  
  org_id = module.gcp_default.org_id
  billing_account_id = module.gcp_default.billing_account_legacy_id
  folder_name = module.gcp_default.folder_name
  project_name = module.gcp_default.control_project_name
  bucket_name = module.gcp_default.control_state_bucket_name
  bucket_location = module.gcp_default.control_state_bucket_location
  service_account_name = module.gcp_default.control_service_account_name
}
