# dfi-labs-infra

Infrastructure management of DFI Labs.

## What

- The goal of this project is to make the entire infrastructure reproducible, collaborative and secure transparently with everyone.
- High level Info:
  - Project: Use K8s (`dir: k8s`)
  - Infra: Terraform / OpenTofu - To setup VMs and K8 clusters (`dir: tf`)
  - Ansible:  For OS, pkg and config management + other raw VM items (`dir: ansible`)
    - Feel free to use ansible for quick tests and migration from old infra until K8s infra is mature.

## Migration plan

- Start with transparent code and infra to visible to the entire team.
- Start with manual deployments as needed but checked in code.
- Switch to CI For core infra management.
- Eventually automate config and key distribution.
- Move as much into K8s
- Make majority of the parts open source.

## Terraform projects

- Standard terraform / opentofu workflow inside each project dir.
  - `cd tf/<project>`
  - `tofu init` - Initialize on first run
  - `tofu plan`
  - `tofu apply`
  
- See [./tf/dfi_labs_bootstrap_gcp/README.md](tf/dfi_labs_bootstrap_gcp/README.md)
- See [./tf/dfi_labs_dev_gcp/README.md](tf/dfi_labs_dev_gcp/README.md)

## Ansible playbooks

- Playbooks are by default targeted to "all" hosts at the moment.
- Playbook inventory is meant to be dynamic, and be defined through the repo-local config.
- For targeting specific plays at specific nodes, target them directly
  - Eg: `ansible-playbook ./ansible/dfi/setup-base.yml -i <host-ip>,` (Note the comma after IP or ansible won't validate)

## Design philosophy

- This includes core infrastructure and as such it's meant to stand the test of time with "the cool trendy stuff" only on higher layers.
- It's the responsibility of the key reviewers to ensure there's no influence of shiny new syndrome that's tied into core infra.
- Keep the core layers agnostic of providers, languages or tool dependencies.

### Why terraform, ansible and k8s

- All of these are tools that are considered standard, open with industry wide best practices built out of learnings spanning decades.
- Use only tools that have stood the test of time and focus on open computing standards and foundations of computer science rather than things that are cool.
- Given enough time horizon, most things that appear cool end up either getting deprecated or the great parts about it being dissipated into the standard open tools. Companies change focus, lose funding, kill products, change pricing - happens all the time - faster than one realizes.

### Why not C/xx, Rust, JavaScript or tools like CDK, Chef, Puppet etc

- Languages: Incredibly smart people with both time and money across startups to big tech have tried and come to the conclusion they just don't hold well to evolve with time and scale.
- Use bash scripts for scripts that tie into these to provide simple bridge of scripting ability where needed.
- Understand the reasoning on why tools like terraform and ansible have come to be known as the open standard tools.
  - Terraform: Thinnest desired state system. It's DSL is simple and keeps things provider and language agnostic.
  - Ansible: Thinnest imperative system. It's possibility the thinnest layer above shell scripting without much learning curve relying on basics of computer science keeping the learning curve shorter for quick automation and DRY.
- Focus on longer time horizon, maintainability and knowledge transfer including easily _enforceable_ best practices that allow isolated free experimentation and high velocity on the top layers, but secure, solid foundations on the bottom.
- It's often better and easier to build a secure, correct and scalable system with simple tools and conventions than complex tools that's harder to understand involving layers that only few people understand or add cognitive or specialized learning overhead.
- Provider specific tools like CDK etc: Imagine from a point of these providers: every large provider is a tech island on their own - it makes sense for them. And they'd rather you're tied in to their ecosystem - that's a massive bonus for them and bane for developers. Every org, as much as you believe will be stuck to a stack will outgrow it in time, if project/business is successful. This results in massive overheads or tie-ins that result in opportunity costs quickly that's harder to recognize when you're already deep in the rat race of maintenance and overheads of specific tech stacks.
- Programming and software engineering will be lot more enjoyable, fun involving least stress on a longer term, when it's based on open standards, simple, and easier to transfer knowledge.
- Would you rather learn something that'll be obsolete in 3 years or tied to a single company or would you learn something that'll you'll serve you for 10+ years? Making clear and disciplined decisions here translates to both the joy and productivity on the longer run.

### Why K8s and containers rather than Vercel, Netlify, X, Y

- K8s and containers should be self explanatory.
- On docker: Prefer `podman` where-ever possible. It's more open, and is key OCI based tool. Also used by big tech and benefit from the mind-share at scale. All container management tools are just APIs over kernel namespaces today anyway. 
  - In addition, has the benefits of open licensing. Fun-fact: Google, RedHat, Oracle, Microsoft etc all use podman related tools like `buildah`, `skopeo`, etc in their OCI based infra. Open sourcing and licensing usually is the winner given a long enough time horizon.
- When we already have the capability for K8s, Knative and complete ecosystem - tools like netlify, vercel, etc no matter how simple they may seem decoupled, not only introduce additional fragmentation and cognitive efforts on a longer time horizon, but also add hard to debug problems that are specific to vendor infrastructure over time on integration of complex pieces of infrastructure.
- Rely on standards. These shouldn't be necessary for productivity for teams that already have the open standards capability and in-fact hinder creativity and flexibility for teams with good conventions using foundational tools. These external services add more value and make more sense to non-tech organizations than one's that are tech focused.
- Standards provide us with precise control over costs.

### Cloud Providers

- Cloud providers are quintessential and provide many capabilities which is harder to achieve without. However, abstract these as much as possible. Use standard well known companies and design infrastructure in a way that any other pieces also use open standards that they can fallback to larger providers with almost no-effort.
- Use AWS, GCP, CloudFlare, Digital Ocean, Vultr, etc as needed, but only use their core infrastructure services (VMs for Compute, HSMs for security, edge networking for DNS, cache, DDoS sink etc).
- Keep all other provider specific aspects (AI, cool new indexer, cool new database, etc) only contained in the application layers or as application based service layers. Don't use them for core infrastructure.
- Note:
  - Even seemingly simple services like direct lambda functions that seem very easy to implement are not open core infrastructure. Containerizing them often not only just makes it way more flexible to grow, manage and deploy across agnostic infrastructure, but also enforces better software programming practices when built as a containers. Takes very little effort and makes it easier to transfer across team.
  - Running containers in lambdas on the other hand are perfectly fine. Just don't depend on lambda specific APIs or provider based services, almost never worth the quick hack to build sustainable anything.
