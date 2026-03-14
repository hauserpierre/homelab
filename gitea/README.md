## Install gitea on rasp cluster

### Create secrets first

```bash
kubectl create namespace gitea

kubectl create secret generic gitea-admin-secret \
  --from-literal=username=<YOUR_ADMIN_USERNAME> \
  --from-literal=password=<YOUR_SECURE_PASSWORD> \
  --from-literal=email=<YOUR_EMAIL> \
  -n gitea

kubectl create secret generic gitea-postgres-secret \
  --from-literal=password=<YOUR_SECURE_PASSWORD> \
  -n gitea
```

### Install

helm repo add gitea-charts https://dl.gitea.io/charts/
helm repo add gitea https://dl.gitea.com/charts/
helm repo update

helm install gitea gitea-charts/gitea -f gitea-values.yaml -n gitea --create-namespace
kubectl get pods -n gitea

## Add to /etc/hosts

<NODE_IP>  gitea.cluster

## Install Gitea Actions Runner (CI/CD)

Get Registration Token from Gitea
In Gitea:
Go to Site Administration
Go to Runners
Click Create Runner
Copy the Runner Registration Token
Paste it into runner-values.yaml:

runner:
registrationToken: "YOUR_TOKEN_HERE"

## Install runners

helm install gitea-runner gitea/gitea-action-runner -f runner-values.yaml -n gitea
kubectl get pods -n gitea

## Test CI/CD with a Workflow

Inside any repo on Gitea, create:
.gitea/workflows/ci.yaml

Push to main → CI should start!

Check:
Gitea → Repo → Actions
