#  dfi-labs-infra

Infrastructure management of DFI Labs.

## What

- The goal of this project is to make the entire infrastructure reproduceable, collaborative and secure transparently with everyone.
- Starting goal:
  - Transparent code for the entire team.
  - Infra creation from CI
  - Infra management from CI
  - Resolve secure key distribution
- Final goal: 
  - Make majority of the parts open source.

## Info

- For infrastructure setup and mutation: Terraform /  OpenTofu (`dir: tf`)
- For infrastructure configuration management:  Ansible (`dir: ansible`)

## How to run 

- Eventual goal is for the CI to take care of all these. For now, it's a mix of manual runs and slow migration to gitops. 

###  GCP Projects

- Create projects:
  - Make sure gcloud is setup with credentials to create project. 
  - `ansible-playbook -i ./ansible/gcp/gcp-setup-project.yml`
    - This does the following:
      - Create project.
      - Link billing to project
      - Create terraform service accounts
      - Setup IAM for terraform service account
      - Setup GCS bucket for terraform state storage
      - Setup IAM for owner user for service account impersonation
- Terraform the projects:
    - Make sure that you have application default credentials setup for GCP
      - `gcloud auth application-default login`
      - Make sure the account you use have service account impersonation permissions (setup by the ansible project)  
    - Standard terraform / opentofu workflow inside each project dir. (Can be executed by CI)
      - `cd tf/<project>`
      - `tofu init` - Initialize on first run
      - `tofu plan`
      - `tofu apply` 

#### Instances 

- If you need manual instances, add them to instances.tf in the project.
- Try to use the recommended types, so it's easier to have high-level sense of sizing and costs without having to looking at pricing calculator.