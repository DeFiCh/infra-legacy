# Find the control project, so that we can refer to this for other things
# like folders
data "google_projects" "control" {
  filter = "id:${module.gcp_default.control_project_name}"
}

locals {
  dev1_project_name = "dfi-labs-dev-tf4"
}

resource "google_project" "dev1" {
  name            = local.dev1_project_name
  project_id      = local.dev1_project_name
  folder_id       = data.google_projects.control.projects[0].parent.id
  billing_account = module.gcp_default.billing_account_legacy_id
}

module "gcp_dev1" {
  source       = "../modules/dfi_labs_dev1_gcp"
  project_name = google_project.dev1.project_id
}