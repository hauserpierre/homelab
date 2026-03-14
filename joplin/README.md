# Joplin Server

Self-hosted [Joplin](https://joplinapp.org/) sync server with a PostgreSQL backend.

## Prerequisites

Create the namespace and the secret before applying manifests:

```bash
kubectl apply -f 00-joplin-namespace.yaml

kubectl create secret generic joplin-secret \
  --from-literal=db-password=<YOUR_SECURE_PASSWORD> \
  -n joplin
```

Or apply the template and fill it in:

```bash
# Edit joplin-secret.yaml to set your password, then:
kubectl apply -f joplin-secret.yaml
```

## Deploy

```bash
kubectl apply -f 01-pvc.yaml
kubectl apply -f 02-postgres-deployment-service.yaml
kubectl apply -f 03-joplin-deployment-server.yaml
kubectl apply -f 04-nodeport.yaml
kubectl apply -f 05-joplin-ingress.yaml
```

## Configuration

- Set `APP_BASE_URL` in `03-joplin-deployment-server.yaml` to the URL clients will use to reach the server (e.g. `http://<NODE_IP>:<NODE_PORT>`).
- Storage: Longhorn PVC (10 Gi by default).
