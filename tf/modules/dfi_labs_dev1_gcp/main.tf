locals {
  project_name = var.project_name
  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
  ]
}