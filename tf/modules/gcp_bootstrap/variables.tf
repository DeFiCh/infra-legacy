
variable org_id {
  type        = string
  default     = ""
  description = "Organization ID"
}

variable billing_account_id {
  type        = string
  default     = ""
  description = "Billing account to be associated with projects"
}

variable folder_name {
  type        = string
  default     = ""
  description = "Root folder under which all projects will be created"
}

variable project_name {
  type        = string
  default     = ""
  description = "The name of the control project to be created"
}

variable bucket_name {
  type        = string
  default     = ""
  description = "The name of the control state bucket to be created"
}

variable bucket_location {
  type        = string
  default     = ""
  description = "Control State Bucket Location: Typically Asia, US or EU"
}

variable service_account_name {
  type        = string
  default     = "tf-control-sa"
  description = "Control service account name"
}

variable service_account_display_name {
  type        = string
  default     = "Terraform Control Service Account"
  description = "Control service account display name"
}

variable service_account_folder_roles {
  type        = list(string)
  default     = [
    "roles/editor",
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.projectCreator",
    # roles/billing.user
    ]
  description = "The roles to grant the control service account on the root folder"
}