# --- Authentik: OIDC identity provider ---
# Enabled with -var deploy_authentik=true (see DEPLOYMENT-PLAN.md).
#
# Manual prerequisite: a secret holding the application key and the
# PostgreSQL password (never stored in the repo):
#   kubectl create secret generic authentik-secrets -n authentik \
#     --from-literal=AUTHENTIK_SECRET_KEY="$(openssl rand -base64 48)" \
#     --from-literal=AUTHENTIK_POSTGRESQL__PASSWORD="$(openssl rand -base64 24)"

resource "helm_release" "authentik" {
  count = var.deploy_authentik ? 1 : 0

  name       = "authentik"
  namespace  = kubernetes_namespace.authentik[0].metadata[0].name
  repository = "https://charts.goauthentik.io"
  chart      = "authentik"
  version    = "2026.5.5"
  timeout    = 600

  values = [local.render.authentik]
}
