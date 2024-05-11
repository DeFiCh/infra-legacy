terraform {
  backend "gcs" {
    # Workaround: Locals / vars currently don't work yet with backend block. Need to be spcified manually.
    # https://github.com/hashicorp/terraform/issues/13022
    # https://github.com/opentofu/opentofu/issues/1042
    bucket  = "dfi-labs-dev-tf3-state"
    prefix  = "tfstate.d"
    impersonate_service_account = "tf-service-account@dfi-labs-dev-tf3.iam.gserviceaccount.com"
  }
}

module "gcp_default" {
  source = "../modules/gcp_default_dfi_labs"
}

locals {
  project_id         = "dfi-labs-dev-tf3"
  tf_service_account = "tf-service-account@${local.project_id}.iam.gserviceaccount.com"

  az = module.gcp_default.az

  default_region = module.gcp_default.default_region
  default_zone   = module.gcp_default.default_zone

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