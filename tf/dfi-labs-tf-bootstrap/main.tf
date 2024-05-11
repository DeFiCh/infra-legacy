locals {
  organization_id = "564950325795"
  billing_account_legacy_id = "01F606-D04835-3532AB" # Legacy
  billing_account_id = "01BA6B-33D914-55E186" # 2024-1

  root_folder_name = "dfi-labs"
  control_project_id = "${ local.root_folder_name }-tf-control"
  control_state_bucket = "${ local.control_project_id }-state"
  control_state_bucket_location      = "Asia"

  az = {
    asia = [{ region: "asia-southeast1", zone: "asia-southeast1-a" }],
    eu   = [{ region: "europe-west1", zone: "europe-west1-b" }],
    us   = [{ region: "us-central1", zone: "us-central1-a" }],
  }

  default_region = local.az.asia[0].region
  default_zone   = local.az.asia[0].zone

  control_service_account = "tf-control-sa"
  control_service_account_display_name = "Terraform Control Service Account"
  control_folder_roles = [
    "roles/editor",
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.projectCreator",
    # roles/billing.user
  ]
}

provider "google" {
  region                      = local.default_region
  zone                        = local.default_zone
}

resource "google_folder" "root" {
  display_name = local.root_folder_name
  parent       = "organizations/${local.organization_id}"
}

# We create the control project. This project hosts global org resource
# state GCS buckets, service accounts and permissions.
resource "google_project" "control" {
  name       = local.control_project_id
  project_id = local.control_project_id
  folder_id  = google_folder.root.name
  billing_account = local.billing_account_legacy_id
}

# Create the service account in control that's the super admin for all projects
# below it.
resource "google_service_account" "control" {
  account_id   = local.control_service_account
  display_name = local.control_service_account_display_name
  project = google_project.control.project_id
}


# Grant the service account owner access to the control project.
resource "google_project_iam_binding" "control" {
  project = google_project.control.project_id
  role    = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.control.email}",
  ]
}

# Grant the service account administer root folder with create and 
# edit access below it.
resource "google_folder_iam_binding" "root" {
  for_each = toset(local.control_folder_roles)
  folder  = google_folder.root.name
  role    = each.key

  members = [
    "serviceAccount:${google_service_account.control.email}",
  ]
}

# The GCS bucket used by service account for control state
# The service account already has access to the bucket since we have 
# given it the project owner role for control.
resource "google_storage_bucket" "control" {
  name          = "${ local.control_state_bucket }"
  location      = local.control_state_bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
  soft_delete_policy {
    // 90 days in seconds, default is 7.
    retention_duration_seconds = 7776000 
  }
  project = google_project.control.project_id
}
