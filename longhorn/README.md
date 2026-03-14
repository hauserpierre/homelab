# Longhorn

Configuration and recovery tooling for [Longhorn](https://longhorn.io/) distributed block storage.

## Contents

- `longhorn-ingress.yaml` — Traefik ingress exposing the Longhorn UI at `longhorn.cluster`
- `longhorn-service.yaml` — Service definition for the Longhorn frontend
- `rediscover-longhorn-volumes.sh` — Script to regenerate Longhorn Volume and Replica manifests for disaster recovery
- `longhorn-recovery-manifests/` — Generated recovery manifests (output of the script above)

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

## Disaster Recovery

If Longhorn loses track of its volumes (e.g. after a cluster rebuild), use the recovery script to regenerate manifests from your known replica layout:

```bash
bash rediscover-longhorn-volumes.sh
kubectl apply -f longhorn-recovery-manifests/00-volumes.yaml
kubectl apply -f longhorn-recovery-manifests/01-replicas.yaml
kubectl -n longhorn get volumes -w
```
