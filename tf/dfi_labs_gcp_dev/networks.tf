resource "google_compute_network" "dev1_main" {
  name                    = "main"
  auto_create_subnetworks = false

  project = google_project.dev1.project_id
}

resource "google_compute_subnetwork" "dev1_main" {
  name          = "main"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.dev1_main.id

  project = google_project.dev1.project_id
}

resource "google_compute_address" "dev1_address_1" {
  name = "address-1"

  project = google_project.dev1.project_id
}