resource "google_compute_firewall" "dev1_ssh" {
  name = "allow-22"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.dev1_main.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]

  project = local.project_name
}
