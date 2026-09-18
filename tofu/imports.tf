# --- Import blocks for existing resources ---
# Declarative: the first `tofu apply` adopts these resources into the state
# without touching the cluster. Once the import is done (the state contains
# them), this file can be deleted. Keeping it has no effect.

import {
  to = kubernetes_namespace.apps["gitea"]
  id = "gitea"
}

import {
  to = kubernetes_namespace.apps["immich"]
  id = "immich"
}

import {
  to = kubernetes_namespace.apps["joplin"]
  id = "joplin"
}

import {
  to = kubernetes_namespace.apps["newflix"]
  id = "newflix"
}

import {
  to = kubernetes_namespace.apps["radicale"]
  id = "radicale"
}

import {
  to = kubernetes_namespace.apps["registry"]
  id = "registry"
}

# helm_release import format: "<namespace>/<release-name>"
import {
  to = helm_release.gitea
  id = "gitea/gitea"
}

import {
  to = helm_release.immich
  id = "immich/immich"
}

import {
  to = helm_release.nfs_provisioner
  id = "kube-system/nfs-provisioner"
}
