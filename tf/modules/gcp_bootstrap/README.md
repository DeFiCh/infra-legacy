# gcp_bootstrap

This module bootstraps GCP for an organization when no resources exist.

## Pre-requisites

- User with admin permissions to setup IAM and create projects.
  - Specifically:
    - Project creator
    - Folder creator
    - IAM to create service account
    - Billing access to attach billing account
- Billing account
- Application default credentials for terraform to access GCP API.
  - `gcloud auth login`
  - `gcloud auth application-default login`

## Design

- Inputs: Check [variables.tf](./variables.tf)

- This module does the following on successful execution:
  - Create GCP folder (`folder_name`).
    - All projects are created inside this.
  - Create control project (`project_name`)
    - Attaches billing account to project (`billing_account_id`)
    - Create service account (`service_account_name`) in the control project
      - This account owns all further projects
      - Enable owner permission for control project
      - Enable permissions to create projects and administer everything inside the root folder
    - Create GCS bucket (`bucket_name`)
      - Setup soft delete lifecycle.  
      - This is used for terraform state.
