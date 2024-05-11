# dfi-labs-tf-bootstrap

The bootstrap project.

## What

- tf-bootstrap -> tf-control -> All other projects.
- tf-bootstrap is a project run manually by an user with permissions
- tf-bootstrap sets up the tf-control project, which can then be used to
manage other projects from CI/CD pipelines.

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
