# OpenTofu: infrastructure as code for the cluster

Manages the cluster namespaces and Helm releases (existing resources imported, plus the new monitoring / Authentik / Teleport layers behind flags).

- **Step-by-step deployment**: [`docs/DEPLOYMENT-PLAN.md`](../docs/DEPLOYMENT-PLAN.md)

## TL;DR

```bash
cp terraform.tfvars.example terraform.tfvars   # first time: fill in domains and IPs (gitignored)
tofu init                                  # first time
tofu plan                                  # show the diff, changes nothing
tofu apply                                 # apply
tofu apply -var deploy_monitoring=true     # enable a layer
```

## Variables

Values files and manifests are shared with the manual `helm` / `kubectl` workflow and contain `${INTERNAL_DOMAIN}`, `${PUBLIC_DOMAIN}`, `${NODE_IP}` and `${NFS_SERVER_IP}` placeholders. `render.tf` replaces them with `var.internal_domain`, `var.public_domain`, `var.node_ip` and `var.nfs_server_ip`, all set in `terraform.tfvars`. Adding a new values file means adding it to `local.rendered_files` and referencing it as `local.render.<name>`.

## State

The state (`terraform.tfstate`) is local and gitignored because it contains rendered secrets. Back it up outside git if you want to protect it (at worst, it can be rebuilt by re-importing).

Not managed here: **traefik** (K3s), **newflix** (Gitea CI/CD), apps deployed as raw manifests (kubectl).
