# Find the control project, so that we can refer to this for other things
# like folders
data "google_projects" "control" {
  filter      = "id:${module.gcp_default.control_project_name}"
}

resource "google_project" "dev1" {
  name            = local.project_dev
  project_id      = local.project_dev
  folder_id       = data.google_projects.control.projects[0].parent.id
  billing_account = module.gcp_default.billing_account_legacy_id
}

resource "google_project_service" "dev1" {
  for_each = toset(local.services)

  project                    = google_project.dev1.project_id
  disable_dependent_services = true
  disable_on_destroy         = false
  service                    = each.key
}

resource "google_compute_project_metadata" "dev1" {
  project = google_project.dev1.project_id
  
  metadata = {
    serial-port-enable = false
    enable-oslogin     = false
    enable-oslogin-2fa = false

    # TODO: Better way to auto pull GH keys from usernames and inject it here 
    ssh-keys = <<EOF
    x:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAAsB0nJcxF0wjuzXK0VTF1jbQbT24C1MM8NesCuwBb github_prasannavl
    EOF
  }
}

# TODO: Provide entire with read access to the project