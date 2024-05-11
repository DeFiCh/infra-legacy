# dfi-labs-infra

Infrastructure management of DFI Labs.

## What

- The goal of this project is to make the entire infrastructure reproducible, collaborative and secure transparently with everyone.
- High level Info:
  - Project: Use K8s (`dir: k8s`)
  - Infra: Terraform / OpenTofu - To setup VMs and K8 clusters (`dir: tf`)
  - Ansible:  For OS, pkg and config management + other raw VM items (`dir: ansible`)
    - Feel free to use ansible for quick tests and migration from old infra until K8s infra is mature.

## Goals

- Starting goal:
  - Transparent code for the entire team.
  - Infra creation from CI
  - Infra management from CI
  - Resolve secure key distribution
  - K8s
- Final goal:
  - Make majority of the parts open source.

## How

- Eventual goal is for the CI to take care of all these. For now, it's a mix of manual runs and slow migration to gitops.
- [TODO] Use k8s to run projects as much as possible, and raw instances primarily as  k8 workers.
- [TODO] Raw instances: Only use if absolutely needed. Ok to use for migration from old infra where-ever needed to ease friction.

### GCP Projects

#### Next

- See [./tf/dfi_labs_gcp_bootstrap/README.md](tf/dfi_labs_gcp_bootstrap/README.md)

#### Legacy

- Create projects:
  - Make sure gcloud is setup with credentials to create project.
  - `ansible-playbook ./ansible/gcp/gcp-setup-project.yml`
    - This does the following:
      - Create project.
      - Link billing to project
      - Create terraform service accounts
      - Setup IAM for terraform service account
      - Setup GCS bucket for terraform state storage
      - Setup IAM for owner user for service account impersonation
- Terraform the projects: (This should already be CI ready, once it's setup)
  - Make sure that you have application default credentials setup for GCP
    - `gcloud auth application-default login`
    - Make sure the account you use have service account impersonation permissions.
  - Standard terraform / opentofu workflow inside each project dir. (Can be executed by CI)
    - `cd tf/<project>`
    - `tofu init` - Initialize on first run
    - `tofu plan`
    - `tofu apply`

#### Instances

- If you need manual instances, add them to instances.tf in the project.
- Try to use the recommended types, so it's easier to have high-level sense of sizing and costs without having to looking at pricing calculator.

### Running ansible playbooks

- Playbooks are by default targeted to "all" hosts at the moment.
- Playbook inventory is meant to be dynamic, and be defined through the repo-local config.
- For targeting specific plays at specific nodes, target them directly
  - Eg: `ansible-playbook ./ansible/dfi/setup-base.yml -i <host-ip>,` (Note the comma after IP or ansible won't validate)
