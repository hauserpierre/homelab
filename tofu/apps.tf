# --- Existing Helm releases, imported from the cluster ---
# The values files remain the source of truth, in the same location as
# before: <service>/<service>-values.yaml. OpenTofu only drives
# `helm upgrade` from them.
#
# Intentionally left out:
#  - traefik / traefik-crd: managed by the K3s HelmChart controller
#    (HelmChartConfig in traefik-config.yaml). Importing them would create
#    an ownership conflict between K3s and OpenTofu.
#  - newflix: deployed by the Gitea CI/CD (the chart lives in the
#    application repo). Same reason: a single owner per release.

resource "helm_release" "gitea" {
  name       = "gitea"
  namespace  = kubernetes_namespace.apps["gitea"].metadata[0].name
  repository = "https://dl.gitea.com/charts/"
  chart      = "gitea"
  version    = "12.6.0"

  values = [local.render.gitea]
}

resource "helm_release" "immich" {
  name      = "immich"
  namespace = kubernetes_namespace.apps["immich"].metadata[0].name
  # Local chart (archived in the repo), no repository.
  chart = "${path.module}/../immich/immich-0.11.1.tgz"

  values = [local.render.immich]
}

resource "helm_release" "nfs_provisioner" {
  name       = "nfs-provisioner"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart      = "nfs-subdir-external-provisioner"
  version    = "4.0.18"

  values = [local.render.nfs_provisioner]
}
