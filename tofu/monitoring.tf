# --- Monitoring stack ---
# Enabled with -var deploy_monitoring=true (see DEPLOYMENT-PLAN.md).
#
# Manual prerequisite (secrets are never stored in the repo, see the root README):
#   kubectl create secret generic grafana-admin -n monitoring \
#     --from-literal=admin-user=admin \
#     --from-literal=admin-password='<password>'
#
# Replaces Promtail (deprecated, end of life March 2026) with the
# OpenTelemetry Collector for log collection.

# The NFS share is mounted as NFSv3 without a lock manager, so flock() fails
# with "no locks available". VictoriaMetrics and Grafana (SQLite) both need a
# lock file. This class uses the same provisioner with the "nolock" mount
# option: locks are handled locally by the client, which is safe for
# single-writer ReadWriteOnce volumes.
resource "kubernetes_storage_class" "nfs_nolock" {
  count = var.deploy_monitoring ? 1 : 0

  metadata {
    name = "nfs-cluster-nolock"
  }

  storage_provisioner    = "cluster.local/nfs-provisioner-nfs-subdir-external-provisioner"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true
  mount_options          = ["nolock"]

  parameters = {
    archiveOnDelete = "true"
  }
}

resource "helm_release" "vm_stack" {
  count = var.deploy_monitoring ? 1 : 0

  name       = "vm-stack"
  namespace  = kubernetes_namespace.monitoring[0].metadata[0].name
  repository = "https://victoriametrics.github.io/helm-charts/"
  chart      = "victoria-metrics-k8s-stack"
  version    = "0.25.5"
  timeout    = 600

  values = [local.render.victoria]

  depends_on = [kubernetes_storage_class.nfs_nolock]
}

resource "helm_release" "loki" {
  count = var.deploy_monitoring ? 1 : 0

  name       = "loki"
  namespace  = kubernetes_namespace.monitoring[0].metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.7.3"
  timeout    = 600

  values = [local.render.loki]
}

resource "helm_release" "otel_collector" {
  count = var.deploy_monitoring ? 1 : 0

  name       = "otel-collector"
  namespace  = kubernetes_namespace.monitoring[0].metadata[0].name
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.165.0"

  values = [local.render.otel]

  # Loki must exist to receive the logs (OTLP endpoint).
  depends_on = [helm_release.loki]
}
