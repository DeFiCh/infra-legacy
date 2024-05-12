
variable "org_id" {
  type        = string
  default     = ""
  description = "Organization ID"
}

variable "billing_account_id" {
  type        = string
  default     = ""
  description = "Billing account to be associated with projects"
}

variable "folder_name" {
  type        = string
  default     = ""
  description = "Root folder under which all projects will be created"
}

variable "project_name" {
  type        = string
  default     = ""
  description = "The name of the control project to be created"
}

variable "project_services" {
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
  ]
  description = "The cloud services API to enable for the project"
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "The name of the control state bucket to be created"
}

variable "bucket_location" {
  type        = string
  default     = ""
  description = "Control State Bucket Location: Typically Asia, US or EU"
}

variable "service_account_name" {
  type        = string
  default     = "tf-control-sa"
  description = "Control service account name"
}

variable "service_account_display_name" {
  type        = string
  default     = "Terraform Control Service Account"
  description = "Control service account display name"
}

variable "service_account_org_roles" {
  type = list(string)
  default = [
    "roles/billing.user",
  ]
  description = "The roles to grant the control service account on the org"
}

variable "service_account_folder_roles" {
  type = list(string)
  default = [
    "roles/editor",
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.projectCreator",
  ]
  description = "The roles to grant the control service account on the root folder"
}

variable "service_account_project_roles" {
  type = list(string)
  default = [
    "roles/owner",
  ]
  description = "The roles to grant the control service account on the project"
}

