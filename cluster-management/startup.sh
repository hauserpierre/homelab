#!/bin/bash

set -e

# Configuration
STATE_DIR="$HOME/cluster-state"
MAX_WAIT=300  # 5 minutes

echo "=== K3s Cluster Startup Procedure ==="
echo ""
echo "NOTE: Ensure all nodes are powered on before running this script"
echo "Master node should boot first, then worker nodes"
echo ""
echo "Press ENTER when all nodes are powered on..."
read

# Step 1: Wait for cluster to be ready
echo ""
echo "[1/5] Waiting for cluster nodes to be ready..."
for i in $(seq 1 $MAX_WAIT); do
  READY_NODES=$(kubectl get nodes --no-headers 2>/dev/null | grep -c " Ready" || echo "0")
  TOTAL_NODES=$(kubectl get nodes --no-headers 2>/dev/null | wc -l || echo "0")

  if [ "$READY_NODES" -eq 4 ] && [ "$TOTAL_NODES" -eq 4 ]; then
    echo "All nodes are ready!"
    kubectl get nodes
    break
  fi

  echo "  Nodes ready: $READY_NODES/4 (waiting... $i/${MAX_WAIT}s)"
  sleep 1
done

if [ "$READY_NODES" -ne 4 ]; then
  echo "ERROR: Not all nodes are ready after ${MAX_WAIT}s"
  echo "Current state:"
  kubectl get nodes
  exit 1
fi

# Step 2: Wait for Longhorn to be ready
echo ""
echo "[2/5] Waiting for Longhorn to be ready..."
for i in $(seq 1 $MAX_WAIT); do
  LONGHORN_READY=$(kubectl get pods -n longhorn --no-headers 2>/dev/null | \
    grep -c "Running" || echo "0")
  LONGHORN_TOTAL=$(kubectl get pods -n longhorn --no-headers 2>/dev/null | wc -l || echo "0")

  if [ "$LONGHORN_TOTAL" -gt 0 ] && [ "$LONGHORN_READY" -eq "$LONGHORN_TOTAL" ]; then
    echo "Longhorn is ready!"
    break
  fi

  echo "  Longhorn pods running: $LONGHORN_READY/$LONGHORN_TOTAL (waiting... $i/${MAX_WAIT}s)"
  sleep 1
done

# Step 3: Verify volumes are available
echo ""
echo "[3/5] Checking Longhorn volumes..."
kubectl get volumes -n longhorn
kubectl get pvc --all-namespaces

# Step 4: Restore application replicas
echo ""
echo "[4/5] Restoring application replicas..."

if [ ! -f "$STATE_DIR/replicas-latest.txt" ]; then
  echo "ERROR: No saved replica state found at $STATE_DIR/replicas-latest.txt"
  echo "Please manually scale your applications"
  exit 1
fi

echo "Using replica state from: $(readlink -f $STATE_DIR/replicas-latest.txt)"

while IFS='|' read -r namespace name type replicas; do
  echo "  Scaling $type $namespace/$name to $replicas replicas"

  if [ "$type" == "deployment" ]; then
    kubectl scale deployment "$name" -n "$namespace" --replicas="$replicas"
  elif [ "$type" == "statefulset" ]; then
    kubectl scale statefulset "$name" -n "$namespace" --replicas="$replicas"
  fi
done < "$STATE_DIR/replicas-latest.txt"

# Step 5: Wait for pods to be ready
echo ""
echo "[5/5] Waiting for application pods to be ready..."
echo "This may take several minutes depending on your applications..."

sleep 10

for i in $(seq 1 $MAX_WAIT); do
  PENDING_PODS=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running,status.phase!=Succeeded 2>/dev/null | \
    grep -v "NAMESPACE" | wc -l || echo "0")

  if [ "$PENDING_PODS" -eq 0 ]; then
    echo "All pods are running!"
    break
  fi

  echo "  Pods still starting: $PENDING_PODS (waiting... $i/${MAX_WAIT}s)"
  sleep 2
done

# Final status
echo ""
echo "=== Cluster Status ==="
echo ""
echo "Nodes:"
kubectl get nodes
echo ""
echo "Pods by namespace:"
kubectl get pods --all-namespaces
echo ""
echo "PVCs:"
kubectl get pvc --all-namespaces
echo ""
echo "=== Startup Complete ==="