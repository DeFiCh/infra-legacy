resource "google_project_service" "dev1" {
  for_each = toset(local.services)

  project                    = local.project_name
  disable_dependent_services = true
  disable_on_destroy         = false
  service                    = each.key
}

resource "google_compute_project_metadata" "dev1" {
  project = local.project_name

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