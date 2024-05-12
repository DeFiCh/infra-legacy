# tf

All the terraform infrastructure.

## Conventions

- High level directories indicate an environment.
- Environments use a set of tf modules under `modules/` so they can be reused and recreated.

### Naming

- Use `<project>_<env>_<provider>` as high level convention.
  - Eg: `dfi_labs_staging_cloudflare`
    - Project = dfi_labs
    - Env = staging (Typically one of `prod/staging/dev/bootstrap/`)
    - Provider = CloudFlare
- Use lowercase only: (Reason: Eliminate dissonance in WTFToCamelCasing/WtfToCamelCase).
- Use `_` only as separators. Don't use `-`. (Reason: Eliminate dissonance_in_project-t)

## Core

- `dfi_labs_bootstrap_gcp`: Project that bootstraps GCP when no resources exist. Run manually with user credentials.
- `dfi_labs_dev_gcp`: Entire dev environment infra.
- `dfi_labs_prod_gcp`: Entire prod environment infra.
- `dfi_labs_staging_gcp`: Entire staging environment infra.
  - Reuse the identical module sets used by prod environment with only differing config.
