terraform {
  backend "gcs" {
    bucket  = "dfi-labs-dev-tf3-state"
    prefix  = "tfstate.d"
    impersonate_service_account = "tf-service-account@dfi-labs-dev-tf3.iam.gserviceaccount.com"
  }
}

locals {
  project_id         = "dfi-labs-dev-tf3"
  tf_service_account = "tf-service-account@${local.project_id}.iam.gserviceaccount.com"

  az = {
    asia = { region : "asia-southeast1", zone : "asia-southeast1-a" },
    eu   = { region : "europe-west1", zone : "europe-west1-b" },
    us   = { region : "us-central1", zone : "us-central1-a" },
  }
  default_region = local.az.asia.region
  default_zone   = local.az.asia.zone
  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
  ]
}

provider "google" {
  project                     = local.project_id
  region                      = local.default_region
  zone                        = local.default_zone
  impersonate_service_account = local.tf_service_account
}