# Home Kubernetes Cluster — Service Configs

Kubernetes manifests and Helm values for the self-hosted services running on my personal Raspberry Pi cluster.

The cluster runs [K3s](https://k3s.io/) on four Raspberry Pi nodes (1 master + 3 workers) with [Longhorn](https://longhorn.io/) for distributed persistent storage and [Traefik](https://traefik.io/) as the ingress controller.

---

## Services

| Directory | Service | Description |
|---|---|---|
| [`gitea/`](./gitea/) | [Gitea](https://gitea.io/) | Self-hosted Git server with CI/CD runners |
| [`immich/`](./immich/) | [Immich](https://immich.app/) | Photo and video backup |
| [`joplin/`](./joplin/) | [Joplin Server](https://joplinapp.org/) | Note sync server |
| [`paperless-ngx/`](./paperless-ngx/) | [Paperless-ngx](https://docs.paperless-ngx.com/) | Document management |
| [`radicale-k8s/`](./radicale-k8s/) | [Radicale](https://radicale.org/) | CalDAV/CardDAV server |
| [`docker-registry/`](./docker-registry/) | Docker Registry | Private container image registry |
| [`longhorn/`](./longhorn/) | Longhorn | Distributed block storage configuration |
| [`dashboard/`](./dashboard/) | Kubernetes Dashboard | Cluster monitoring UI |
| [`storage/`](./storage/) | Storage Classes | NFS StorageClass definitions |
| [`backups/`](./backups/) | Backup scripts | Utility to copy data out of running pods |
| [`cluster-management/`](./cluster-management/) | Cluster scripts | Graceful shutdown and startup procedures |

---

## Secrets

Credentials are **never stored in this repository**. Each service directory contains a `*-secret.yaml` template and a README with the `kubectl create secret` command to run before deploying.

---

## Stack

- **Orchestration**: K3s (lightweight Kubernetes)
- **Storage**: Longhorn (distributed block storage over the Pi nodes)
- **Ingress**: Traefik
- **Package manager**: Helm
- **Nodes**: Raspberry Pi (ARM64)
