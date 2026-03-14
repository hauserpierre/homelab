#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <namespace> <pod-or-deployment> <source_dir_in_pod> <local_destination_dir>"
  exit 1
fi

NAMESPACE="$1"
TARGET="$2"
SRC_DIR="$3"
DEST_DIR="$4"

# Ensure destination exists
mkdir -p "$DEST_DIR"

# Resolve deployment to a pod if needed
if kubectl -n "$NAMESPACE" get deployment "$TARGET" >/dev/null 2>&1; then
  POD=$(kubectl -n "$NAMESPACE" get pods \
    -l app="$TARGET" \
    -o jsonpath='{.items[0].metadata.name}')
else
  POD="$TARGET"
fi

echo "Using pod: $POD"
echo "Copying from: $SRC_DIR"
echo "Copying to:   $DEST_DIR"
echo "Skipping existing files..."

kubectl -n "$NAMESPACE" exec "$POD" -- \
  tar cf - -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")" \
| tar xf - -C "$DEST_DIR" --skip-old-files

echo "Done."

## ./kubectl_cp_skip_existing.sh <namespace> <my-pod> /data/uploads ./uploads