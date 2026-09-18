variable "kubeconfig_path" {
  description = "Path to the kubeconfig used by the kubernetes and helm providers"
  type        = string
  default     = "~/.kube/config"
}

# --- Deployment switches ---
# Everything defaults to false: the first `tofu apply` only imports what
# already exists. Layers are then enabled one at a time (see DEPLOYMENT-PLAN.md):
#   tofu apply -var deploy_monitoring=true
# The value is then pinned in a terraform.tfvars file so the -var flag does
# not have to be passed every time.

variable "deploy_monitoring" {
  description = "Deploys the monitoring stack (VictoriaMetrics, Loki, OTel Collector)"
  type        = bool
  default     = false
}

variable "deploy_authentik" {
  description = "Deploys Authentik (OIDC identity provider)"
  type        = bool
  default     = false
}

variable "deploy_teleport" {
  description = "Deploys Teleport (audited SSH/kubectl access with session recording)"
  type        = bool
  default     = false
}

# Cluster-specific values. Values files and manifests reference them as
# ${INTERNAL_DOMAIN}, ${PUBLIC_DOMAIN}, ... (same syntax as scripts/render.sh)
# and are rendered through local.render in render.tf.
# Real values live in terraform.tfvars (gitignored).

variable "internal_domain" {
  description = "Internal TLD resolved by the LAN DNS, services answer on <service>.<internal_domain>"
  type        = string
  default     = "cluster"
}

variable "public_domain" {
  description = "Public (sub)domain covered by the wildcard certificate"
  type        = string
  default     = "cluster.example.com"
}

variable "node_ip" {
  description = "IP of a cluster node, used for NodePort URLs"
  type        = string
  default     = ""
}

variable "nfs_server_ip" {
  description = "IP of the NFS server backing the nfs-cluster StorageClass"
  type        = string
}
