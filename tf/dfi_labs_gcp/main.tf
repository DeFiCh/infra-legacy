locals {
  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
  ]
}

provider "google" {
  region                      = local.default_region
  zone                        = local.default_zone
}