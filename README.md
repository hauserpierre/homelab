# Home Kubernetes Cluster: Service Configs

Kubernetes manifests and Helm values for the self-hosted services running on my personal Raspberry Pi cluster.

The cluster runs [K3s](https://k3s.io/) on four Raspberry Pi nodes (1 master + 3 workers) with [Longhorn](https://longhorn.io/) for distributed persistent storage and [Traefik](https://traefik.io/) as the ingress controller.

---

## Services

| Directory | Service | Description |
|---|---|---|
| [`gitea/`](./gitea/) | [Gitea](https://gitea.io/) | Self-hosted Git server with CI/CD runners |
| [`immich/`](./immich/) | [Immich](https://immich.app/) | Photo and video backup |
| [`joplin/`](./joplin/) | [Joplin Server](https://joplinapp.org/) | Note sync server |
| [`radicale-k8s/`](./radicale-k8s/) | [Radicale](https://radicale.org/) | CalDAV/CardDAV server |
| [`docker-registry/`](./docker-registry/) | Docker Registry | Private container image registry |
| [`longhorn/`](./longhorn/) | Longhorn | Distributed block storage configuration |
| [`storage/`](./storage/) | Storage Classes | NFS StorageClass definitions |
| [`backups/`](./backups/) | Backup scripts | Utility to copy data out of running pods |
| [`monitoring/`](./monitoring/) | Monitoring stack | VictoriaMetrics + Loki + OTel Collector + Grafana |
| [`cluster-management/`](./cluster-management/) | Cluster scripts | Graceful shutdown and startup procedures |
| [`tofu/`](./tofu/) | OpenTofu | Infrastructure as code: namespaces + Helm releases (existing imported, new layers behind flags) |
| [`security/`](./security/) | WAF (optional) | Coraza + OWASP CRS as a Traefik plugin |

**New layers (Authentik OIDC, Teleport, monitoring) are rolled out via OpenTofu.**

---

## Secrets & personal config

Credentials and personal values are **never stored in this repository**.

| What | In the repo | Real value (gitignored) |
|---|---|---|
| Kubernetes Secrets | `*-secret.yaml` templates with `<CHANGE_ME>` | `*-secret.local.yaml` next to the template |
| htpasswd / API tokens | (none) | `radicale-k8s/auth`, `public-network/*token*.txt` |
| Node / NFS IPs, public domain, e-mail | `${NODE_IP}`, `${NFS_SERVER_IP}`, `${TRAEFIK_LB_IP}`, `example.com`, `${ACME_EMAIL}` | `cluster.env` (see `cluster.env.example`) |
| OpenTofu state / vars | `terraform.tfvars.example` | `*.tfstate`, `*.tfvars` |

```bash
kubectl apply -f gitea/gitea-secret.local.yaml                        # real secret
scripts/render.sh immich/immich-ingress.yaml | kubectl apply -f -      # placeholders -> cluster.env values
ln -sf ../../scripts/pre-commit .git/hooks/pre-commit                  # guard: blocks secrets at commit time
```

## Stack

- **Orchestration**: K3s (lightweight Kubernetes)
- **Storage**: NFS via nfs-subdir-external-provisioner (`nfs-cluster` StorageClass); Longhorn configs kept for reference
- **Ingress**: Traefik (managed by K3s)
- **Deployment**: OpenTofu (kubernetes + helm providers), see [`tofu/`](./tofu/)
- **Observability**: VictoriaMetrics (metrics) + Loki (logs) + OpenTelemetry Collector (collection) + Grafana
- **Identity**: Authentik (OIDC)
- **Access**: Teleport (audited SSH/kubectl, session recording)
- **Nodes**: Raspberry Pi 4 (ARM64)
