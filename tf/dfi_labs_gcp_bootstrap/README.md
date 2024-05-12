# dfi-labs-tf-bootstrap

The bootstrap project when no other resources exist.

## What

- `dfi_labs_gcp_bootstrap` -> `dfi_labs_gcp` -> All other projects through CI/CD.
- `dfi_labs_gcp_bootstrap` is run manually by an user with permissions.
- `dfi_labs_gcp_bootstrap` sets up the required items for `dfi_labs_gcp`, which can then be used to
manage other projects from CI/CD pipelines.

- For more info, see [modules/gcp_bootstrap](../modules/gcp_bootstrap/README.md)

## Notes

- Strictly no sensitive info in bootstrap project.
- The `terraform.tfstate` for the bootstrap is checked into git, since it's
  meant to only be run to bootstrap when no other resources exist.
- This should not contain any secrets or sensitive info, as it's meant to
  purely bootstrap the control project, which then takes control and uses
  buckets to store it's state centrally without VCS.
- However, it's the responsibility of bootstrap project to ensure it's own
  security.
- Ref:
  - https://github.com/hashicorp/terraform/issues/516
  - https://stackoverflow.com/questions/38486335/should-i-commit-tfstate-files-to-git
