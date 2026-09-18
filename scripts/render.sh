#!/usr/bin/env bash
# Render manifests or Helm values with the real values from cluster.env (gitignored).
# Only the variables listed below are substituted, any other ${...} is left untouched.
#
#   scripts/render.sh immich/immich-ingress.yaml | kubectl apply -f -
#   helm upgrade gitea gitea-charts/gitea -n gitea -f <(scripts/render.sh gitea/gitea-values.yaml)
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
[ -f "$root/cluster.env" ] || { echo "cluster.env missing (copy cluster.env.example)" >&2; exit 1; }
set -a; . "$root/cluster.env"; set +a
VARS='${INTERNAL_DOMAIN} ${PUBLIC_DOMAIN} ${ACME_EMAIL} ${NODE_IP} ${NFS_SERVER_IP} ${TRAEFIK_LB_IP}'
cat "$@" | envsubst "$VARS"
