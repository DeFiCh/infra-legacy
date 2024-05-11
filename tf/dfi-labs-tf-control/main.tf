locals {
  az = {
    asia = [{ region: "asia-southeast1", zone: "asia-southeast1-a" }],
    eu   = [{ region: "europe-west1", zone: "europe-west1-b" }],
    us   = [{ region: "us-central1", zone: "us-central1-a" }],
  }

  default_region = local.az.asia[0].region
  default_zone   = local.az.asia[0].zone

  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
  ]
}

provider "google" {
  region                      = local.default_region
  zone                        = local.default_zone
}