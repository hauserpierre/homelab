# create namespace

kubectl apply -f immich-namespace.yaml

# create secret

kubectl create secret generic immich-secret \
  --from-literal=db-username=<YOUR_DB_USERNAME> \
  --from-literal=db-password=<YOUR_SECURE_PASSWORD> \
  -n immich

# create pvc

kubectl apply -f immich-pvc.yaml -n immich
kubectl apply -f immich-postgres-pvc.yaml -n immich

# create service for postgres

kubectl apply -f postgres-service.yaml -n immich

# create deployment for postgres

kubectl apply -f postgres-deployment.yaml -n immich

# install packaged helm chart

helm install immich immich-0.11.1.tgz -f values.yaml -n immich

# Change server service to have NodePort 

kubectl apply -f immich-service-nodeport.yaml

# Restore backup in .sql

sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" backup-immich-last.sql \
| psql --dbname=immich --username=admin
