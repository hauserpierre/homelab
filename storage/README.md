# Storage

StorageClass definitions for the cluster.

## Contents

- `nfs-storage-class.yaml` — NFS-backed StorageClass using the NFS subdir external provisioner
- `nfs-cluster-storage-class.yaml` — Cluster-scoped variant of the NFS StorageClass
- `test-pvc.yaml` — PVC for testing storage provisioning

## Install the NFS Provisioner

```bash
helm repo add nfs-subdir-external-provisioner \
  https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=<YOUR_NFS_SERVER_IP> \
  --set nfs.path=<YOUR_NFS_EXPORT_PATH> \
  --namespace nfs-provisioner --create-namespace
```

## Apply StorageClasses

```bash
kubectl apply -f nfs-storage-class.yaml
kubectl apply -f nfs-cluster-storage-class.yaml
```

## Test

```bash
kubectl apply -f test-pvc.yaml
kubectl get pvc
```
