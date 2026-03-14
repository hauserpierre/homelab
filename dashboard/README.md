# Kubernetes Dashboard

Ingress and RBAC manifests for the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard).

## Deploy

```bash
# Install the dashboard (if not already installed)
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace --namespace kubernetes-dashboard

# Apply the ingress and service account
kubectl apply -f dashboard-service-account.yaml
kubectl apply -f dashboard-ingress.yaml
```

## Access

The dashboard is exposed via Traefik at `http://<YOUR_CLUSTER_HOST>/dashboard`.

To get a login token:

```bash
kubectl -n kubernetes-dashboard create token admin-user
```
