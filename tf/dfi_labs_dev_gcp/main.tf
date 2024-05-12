terraform {
  backend "gcs" {
    # Workaround: Locals / vars currently don't work yet with backend block. Need to be spcified manually.
    # https://github.com/hashicorp/terraform/issues/13022
    # https://github.com/opentofu/opentofu/issues/1042
    bucket                      = "dfi-labs-control-state"
    prefix                      = "dfi-labs-dev-tfstate.d"
    impersonate_service_account = "tf-control-sa@dfi-labs-control.iam.gserviceaccount.com"
  }
}

module "gcp_default" {
  source = "../modules/dfi_labs_defaults_gcp"
}

provider "google" {
  region                      = module.gcp_default.default_region
  zone                        = module.gcp_default.default_zone
  impersonate_service_account = module.gcp_default.control_service_account_email
}
