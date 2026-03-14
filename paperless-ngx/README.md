# Install

helm repo add gabe565 https://charts.gabe565.com
helm repo update

# Create secret before deploying

kubectl create namespace paperless

kubectl create secret generic paperless-secret \
  --from-literal=db-password=<YOUR_SECURE_PASSWORD> \
  -n paperless

kubectl apply -f paperless-postgres.yaml
kubectl apply -f paperless-redis.yaml
helm install paperless-ngx gabe565/paperless-ngx -f paperless-ngx-values.yaml -n paperless

# First login 

kubectl exec -it pod/paperless-ngx-xxxxx -n paperless -- \
python3 manage.py createsuperuser