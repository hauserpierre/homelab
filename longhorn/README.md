# Longhorn

Configuration for [Longhorn](https://longhorn.io/) distributed block storage.

## Contents

- `longhorn-ingress.yaml`: Traefik ingress exposing the Longhorn UI at `longhorn.${INTERNAL_DOMAIN}`
- `longhorn-service.yaml`: Service definition for the Longhorn frontend
- `longhorn-values.yaml`: Helm values used for the Longhorn release

## Install Longhorn

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn --create-namespace
```

## Expose the UI

```bash
kubectl apply -f longhorn-ingress.yaml
```