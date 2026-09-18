# --- Existing application namespaces ---
# Imported from the cluster (see imports.tf). Applications deployed as raw
# manifests (joplin, radicale, registry...) are still managed with kubectl;
# only the namespace is tracked here.

locals {
  app_namespaces = [
    "gitea",
    "immich",
    "joplin",
    "newflix",
    "radicale",
    "registry",
  ]
}

resource "kubernetes_namespace" "apps" {
  for_each = toset(local.app_namespaces)

  metadata {
    name = each.value
  }
}

# --- Namespaces for the new layers ---

resource "kubernetes_namespace" "monitoring" {
  count = var.deploy_monitoring ? 1 : 0

  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "authentik" {
  count = var.deploy_authentik ? 1 : 0

  metadata {
    name = "authentik"
  }
}

resource "kubernetes_namespace" "teleport" {
  count = var.deploy_teleport ? 1 : 0

  metadata {
    name = "teleport"
  }
}
