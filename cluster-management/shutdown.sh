#!/bin/bash

set -e

# Configuration — edit these values to match your cluster
WORKER_NODES=("worker01" "worker02" "worker03")
CLUSTER_USER="${USER}"
STATE_DIR="$HOME/cluster-state"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create state directory
mkdir -p "$STATE_DIR"

echo "=== K3s Cluster Shutdown Procedure ==="
echo "Timestamp: $TIMESTAMP"

# Step 1: Save current state
echo ""
echo "[1/10] Saving cluster state..."
kubectl get pods --all-namespaces -o wide > "$STATE_DIR/pods-state-$TIMESTAMP.txt"
kubectl get deployments --all-namespaces -o json > "$STATE_DIR/deployments-$TIMESTAMP.json"
kubectl get statefulsets --all-namespaces -o json > "$STATE_DIR/statefulsets-$TIMESTAMP.json"
kubectl get daemonsets --all-namespaces -o json > "$STATE_DIR/daemonsets-$TIMESTAMP.json"

# Extract replica counts
echo "[1/10] Saving replica counts..."
kubectl get deployments --all-namespaces -o json | \
  jq -r '.items[] | select(.metadata.namespace != "kube-system" and .metadata.namespace != "longhorn") |
  "\(.metadata.namespace)|\(.metadata.name)|deployment|\(.spec.replicas)"' \
  > "$STATE_DIR/replicas-$TIMESTAMP.txt"

kubectl get statefulsets --all-namespaces -o json | \
  jq -r '.items[] | select(.metadata.namespace != "kube-system" and .metadata.namespace != "longhorn") |
  "\(.metadata.namespace)|\(.metadata.name)|statefulset|\(.spec.replicas)"' \
  >> "$STATE_DIR/replicas-$TIMESTAMP.txt"

# Create symlink to latest state
ln -sf "$STATE_DIR/replicas-$TIMESTAMP.txt" "$STATE_DIR/replicas-latest.txt"

echo "Saved state to: $STATE_DIR/"

# Step 2: Verify Longhorn backups
echo ""
echo "[2/10] Checking Longhorn backup status..."
kubectl get backups -n longhorn
echo "Press ENTER to continue or CTRL+C to abort and check backups..."
read

# Step 3: Scale down Deployments (except kube-system and longhorn)
echo ""
echo "[3/10] Scaling down Deployments..."
kubectl get deployments --all-namespaces -o json | \
  jq -r '.items[] | select(.metadata.namespace != "kube-system" and .metadata.namespace != "longhorn") |
  "\(.metadata.namespace) \(.metadata.name)"' | \
  while read ns name; do
    echo "  Scaling down deployment: $ns/$name"
    kubectl scale deployment "$name" -n "$ns" --replicas=0
  done

# Step 4: Scale down StatefulSets (except kube-system and longhorn)
echo ""
echo "[4/10] Scaling down StatefulSets..."
kubectl get statefulsets --all-namespaces -o json | \
  jq -r '.items[] | select(.metadata.namespace != "kube-system" and .metadata.namespace != "longhorn") |
  "\(.metadata.namespace) \(.metadata.name)"' | \
  while read ns name; do
    echo "  Scaling down statefulset: $ns/$name"
    kubectl scale statefulset "$name" -n "$ns" --replicas=0
  done

# Step 5: Wait for pods to terminate
echo ""
echo "[5/10] Waiting for application pods to terminate..."
echo "Waiting up to 5 minutes..."
for i in {1..60}; do
  RUNNING_PODS=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running | \
    grep -v "kube-system\|longhorn\|NAMESPACE" | wc -l)

  if [ "$RUNNING_PODS" -eq 0 ]; then
    echo "All application pods terminated successfully"
    break
  fi

  echo "  Still running: $RUNNING_PODS pods (check $i/60)"
  sleep 5
done

# Step 6: Detach Longhorn volumes
echo ""
echo "[6/10] Detaching Longhorn volumes..."
kubectl get volumes -n longhorn -o json | \
  jq -r '.items[] | select(.status.state == "attached") | .metadata.name' | \
  while read vol; do
    echo "  Detaching volume: $vol"
    kubectl patch volume "$vol" -n longhorn \
      -p '{"spec":{"nodeID":""}}' --type=merge
  done

# Step 7: Wait for volumes to detach
echo ""
echo "[7/10] Waiting for volumes to detach..."
echo "Waiting up to 5 minutes..."
for i in {1..60}; do
  ATTACHED_VOLS=$(kubectl get volumes -n longhorn -o json | \
    jq -r '.items[] | select(.status.state == "attached") | .metadata.name' | wc -l)

  if [ "$ATTACHED_VOLS" -eq 0 ]; then
    echo "All volumes detached successfully"
    break
  fi

  echo "  Still attached: $ATTACHED_VOLS volumes (check $i/60)"
  sleep 5
done

# Step 8: Stop k3s on worker nodes
echo ""
echo "[8/10] Stopping k3s on worker nodes..."
for node in "${WORKER_NODES[@]}"; do
  echo "  Stopping k3s-agent on $node..."
  ssh ${CLUSTER_USER}@"$node" "sudo systemctl stop k3s-agent" || echo "  Warning: Failed to stop k3s-agent on $node"
done

sleep 5

# Step 9: Stop k3s on master
echo ""
echo "[9/10] Stopping k3s on master node..."
sudo systemctl stop k3s

sleep 3

# Step 10: Shutdown nodes
echo ""
echo "[10/10] Shutting down cluster nodes..."
echo "Shutdown order: workers first, then master"
echo "Press ENTER to shutdown all nodes or CTRL+C to abort..."
read

for node in "${WORKER_NODES[@]}"; do
  echo "  Shutting down $node..."
  ssh ${CLUSTER_USER}@"$node" "sudo shutdown -h now" &
done

sleep 10

echo "  Shutting down master node..."
sudo shutdown -h now