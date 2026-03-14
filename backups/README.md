# Backups

Utility script to copy data out of a running pod using `kubectl exec` + `tar`.

## Usage

```bash
./backup-pods.sh <namespace> <pod-or-deployment> <source_dir_in_pod> <local_destination_dir>
```

### Example

```bash
# Backup the /data/uploads directory from a deployment called "myapp"
./backup-pods.sh myapp-namespace myapp /data/uploads ./local-backup
```

The script resolves a Deployment name to one of its pods automatically.
Existing local files are skipped (`--skip-old-files`).
