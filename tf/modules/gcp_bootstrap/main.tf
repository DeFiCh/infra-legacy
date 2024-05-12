locals {
  // 90 days in seconds, default is 7 days.
  control_bucket_soft_delete_duration_seconds = 7776000
}

resource "google_folder" "root" {
  display_name = var.folder_name
  parent       = "organizations/${var.org_id}"
}

# We create the control project. This project hosts global org resource
# state GCS buckets, service accounts and permissions.
resource "google_project" "control" {
  name            = var.project_name
  project_id      = var.project_name
  folder_id       = google_folder.root.name
  billing_account = var.billing_account_id
}

# Enable the services in the control project so that service account
# can create resources in the projects below it that involve core API access.
resource "google_project_service" "default" {
  for_each = toset(var.project_services)

  project                    = google_project.control.project_id
  disable_on_destroy         = true
  disable_dependent_services = true
  service                    = each.key
}

# Create the service account in control that's the super admin for all projects
# below it.
resource "google_service_account" "control" {
  account_id   = var.service_account_name
  display_name = var.service_account_display_name
  project      = google_project.control.project_id
}

# Grant the service account owner access to the control project.
resource "google_organization_iam_binding" "control" {
  for_each = toset(var.service_account_org_roles)

  org_id = var.org_id
  role   = each.key

  members = [
    "serviceAccount:${google_service_account.control.email}",
  ]
}

# Grant the service account administer root folder with create and 
# edit access below it.
resource "google_folder_iam_binding" "root" {
  for_each = toset(var.service_account_folder_roles)
  folder   = google_folder.root.name
  role     = each.key

  members = [
    "serviceAccount:${google_service_account.control.email}",
  ]
}

# Grant the service account owner access to the control project.
resource "google_project_iam_binding" "control" {
  for_each = toset(var.service_account_project_roles)

  project = google_project.control.project_id
  role    = each.key

  members = [
    "serviceAccount:${google_service_account.control.email}",
  ]
}

# The GCS bucket used by service account for control state
# The service account already has access to the bucket since we have 
# given it the project owner role for control.
resource "google_storage_bucket" "control" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
  soft_delete_policy {
    retention_duration_seconds = local.control_bucket_soft_delete_duration_seconds
  }
  project = google_project.control.project_id
}
