# --- Teleport: audited SSH/kubectl access with session recording ---
# Enabled with -var deploy_teleport=true (see DEPLOYMENT-PLAN.md).
#
# The proxy is exposed through Traefik in TLS passthrough mode
# (IngressRouteTCP): Teleport handles its own TLS, Traefik only routes the
# teleport.${INTERNAL_DOMAIN} SNI to the service.

resource "helm_release" "teleport" {
  count = var.deploy_teleport ? 1 : 0

  name       = "teleport"
  namespace  = kubernetes_namespace.teleport[0].metadata[0].name
  repository = "https://charts.releases.teleport.dev"
  chart      = "teleport-cluster"
  version    = "18.10.0"
  timeout    = 600

  values = [local.render.teleport]
}

resource "kubernetes_manifest" "teleport_ingressroutetcp" {
  count = var.deploy_teleport ? 1 : 0

  manifest = yamldecode(local.render.teleport_route)

  depends_on = [helm_release.teleport]
}
