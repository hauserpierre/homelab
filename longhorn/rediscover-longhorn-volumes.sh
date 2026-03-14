#!/bin/bash
# Longhorn Volume Recovery Script
# This script generates YAML manifests to recover your volumes

set -e

OUTPUT_DIR="longhorn-recovery-manifests"
mkdir -p "$OUTPUT_DIR"

echo "Generating Longhorn recovery manifests..."

cat > "$OUTPUT_DIR/00-volumes.yaml" << 'EOF'
# Volume definitions
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 3
  size: "21474836480"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 3
  size: "1073741824"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 3
  size: "10737418240"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 2
  size: "322122547200"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-31982d4c-475e-42e3-b394-124973bdda7e
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 3
  size: "21474836480"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 3
  size: "8589934592"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 3
  size: "53687091200"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 2
  size: "1073741824"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-4c89ac47-d08d-48bf-9265-493249ecedad
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 2
  size: "21474836480"
  staleReplicaTimeout: 30
---
apiVersion: longhorn.io/v1beta2
kind: Volume
metadata:
  name: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806
  namespace: longhorn
spec:
  diskSelector: []
  frontend: blockdev
  nodeSelector: []
  numberOfReplicas: 2
  size: "1073741824"
  staleReplicaTimeout: 30
EOF

cat > "$OUTPUT_DIR/01-replicas.yaml" << 'EOF'
# Replica definitions
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53-e940cb6a
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53-e940cb6a
  volumeName: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53-31790985
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53-31790985
  volumeName: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53-bd8885db
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53-bd8885db
  volumeName: pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5-c2be32c9
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5-c2be32c9
  volumeName: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5
  volumeSize: "1073741824"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5-638b9633
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5-638b9633
  volumeName: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5
  volumeSize: "1073741824"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5-24f959ad
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5-24f959ad
  volumeName: pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5
  volumeSize: "1073741824"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6-2ad5d354
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6-2ad5d354
  volumeName: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6
  volumeSize: "10737418240"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6-a9d27329
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6-a9d27329
  volumeName: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6
  volumeSize: "10737418240"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6-a770ee83
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6-a770ee83
  volumeName: pvc-42ed8396-1067-4c2b-804a-24341e24b4a6
  volumeSize: "10737418240"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371-b5b8d5f3
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371-b5b8d5f3
  volumeName: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371
  volumeSize: "322122547200"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371-21284939
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371-21284939
  volumeName: pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371
  volumeSize: "322122547200"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-31982d4c-475e-42e3-b394-124973bdda7e-ae574a41
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-31982d4c-475e-42e3-b394-124973bdda7e-ae574a41
  volumeName: pvc-31982d4c-475e-42e3-b394-124973bdda7e
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-31982d4c-475e-42e3-b394-124973bdda7e-83aceb3e
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-31982d4c-475e-42e3-b394-124973bdda7e-83aceb3e
  volumeName: pvc-31982d4c-475e-42e3-b394-124973bdda7e
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-31982d4c-475e-42e3-b394-124973bdda7e-cc126aaa
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-31982d4c-475e-42e3-b394-124973bdda7e-cc126aaa
  volumeName: pvc-31982d4c-475e-42e3-b394-124973bdda7e
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00-8e2473fd
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00-8e2473fd
  volumeName: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00
  volumeSize: "8589934592"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00-e84fbc05
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00-e84fbc05
  volumeName: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00
  volumeSize: "8589934592"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00-a2de393e
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00-a2de393e
  volumeName: pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00
  volumeSize: "8589934592"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea-0a079720
  namespace: longhorn
spec:
  active: true
  nodeID: cube04
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea-0a079720
  volumeName: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea
  volumeSize: "53687091200"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea-887f0b47
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea-887f0b47
  volumeName: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea
  volumeSize: "53687091200"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea-8608f906
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea-8608f906
  volumeName: pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea
  volumeSize: "53687091200"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd-ce1e67db
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd-ce1e67db
  volumeName: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd
  volumeSize: "1073741824"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd-217403ad
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd-217403ad
  volumeName: pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd
  volumeSize: "1073741824"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-4c89ac47-d08d-48bf-9265-493249ecedad-2f41358d
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-4c89ac47-d08d-48bf-9265-493249ecedad-2f41358d
  volumeName: pvc-4c89ac47-d08d-48bf-9265-493249ecedad
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-4c89ac47-d08d-48bf-9265-493249ecedad-92b855c4
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-4c89ac47-d08d-48bf-9265-493249ecedad-92b855c4
  volumeName: pvc-4c89ac47-d08d-48bf-9265-493249ecedad
  volumeSize: "21474836480"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806-7d90a02f
  namespace: longhorn
spec:
  active: true
  nodeID: cube01
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806-7d90a02f
  volumeName: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806
  volumeSize: "1073741824"
---
apiVersion: longhorn.io/v1beta2
kind: Replica
metadata:
  name: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806-79614efa
  namespace: longhorn
spec:
  active: true
  nodeID: cube03
  diskID: default-disk-de2c7f1ae8067951
  diskPath: /media/DATA
  dataDirectoryName: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806-79614efa
  volumeName: pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806
  volumeSize: "1073741824"
EOF

echo ""
echo "✓ Manifests generated in $OUTPUT_DIR/"
echo ""
echo "Volume summary:"
echo "  pvc-f167fbcd-c0f1-4ee6-b1fe-a28545cf8d53 - 20 GiB (3 replicas)"
echo "  pvc-cf13638f-9c98-42c8-b793-ac30af2b23a5 - 1 GiB (3 replicas)"
echo "  pvc-42ed8396-1067-4c2b-804a-24341e24b4a6 - 10 GiB (3 replicas)"
echo "  pvc-fcfe2a57-e255-4d5b-a366-fb0f64098371 - 300 GiB (2 replicas) - Immich data?"
echo "  pvc-31982d4c-475e-42e3-b394-124973bdda7e - 20 GiB (3 replicas)"
echo "  pvc-913fe3eb-997a-486d-bce7-b91bd17a3f00 - 8 GiB (3 replicas)"
echo "  pvc-2008639f-0bbe-46d4-ba42-4f87cef3d1ea - 50 GiB (3 replicas)"
echo "  pvc-0d324ffa-c91e-4239-ba08-859cc9f165dd - 1 GiB (2 replicas)"
echo "  pvc-4c89ac47-d08d-48bf-9265-493249ecedad - 20 GiB (2 replicas)"
echo "  pvc-3d16299a-48d7-4b8e-963f-9c1f00e26806 - 1 GiB (2 replicas)"
echo ""
echo "Next steps:"
echo "1. Review the generated YAML files"
echo "2. Apply volumes: kubectl apply -f $OUTPUT_DIR/00-volumes.yaml"
echo "3. Apply replicas: kubectl apply -f $OUTPUT_DIR/01-replicas.yaml"
echo "4. Watch volume recovery: kubectl -n longhorn get volumes -w"
echo "5. Check Longhorn UI for volume status"