# Private Docker Registry

A self-hosted Docker registry secured with htpasswd basic auth, exposed via Traefik.

## Prerequisites

Generate the htpasswd credentials and store them in a Kubernetes Secret:

```bash
# Install htpasswd if needed: apt install apache2-utils
htpasswd -Bbn <USERNAME> <PASSWORD> > htpasswd

kubectl create namespace registry

kubectl create secret generic registry-auth \
  --from-file=htpasswd=./htpasswd \
  -n registry
```

## Deploy

```bash
kubectl apply -f docker-registry-namespace.yaml
kubectl apply -f docker-pvc.yaml
kubectl apply -f docker-registry-deployment.yaml
kubectl apply -f docker-registry-service.yaml
kubectl apply -f docker-registry-middleware.yaml
kubectl apply -f docker-registry-ingressroute.yaml
```

## Usage

```bash
docker login <YOUR_REGISTRY_HOST>
docker tag myimage <YOUR_REGISTRY_HOST>/myimage:latest
docker push <YOUR_REGISTRY_HOST>/myimage:latest
```
