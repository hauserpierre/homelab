# Monitoring

Cluster observability: metrics with VictoriaMetrics, logs with Loki collected by the OpenTelemetry Collector, visualization with Grafana.

## Architecture

```
Nodes / Pods
  |
  +-- node-exporter (DaemonSet)       -> system metrics (CPU, RAM, disk, temp.)
  +-- kube-state-metrics              -> K8s object metrics (pods, PVCs...)
  +-- OTel Collector (DaemonSet)      -> log collection from all pods
        |
        +--> vmagent --> VMSingle     -> metrics storage (NFS 8Gi, 3 months)
        +--> Loki (OTLP endpoint)     -> log storage (NFS 20Gi, 31 days)
                |
                +--> Grafana          -> UI (http://grafana.${INTERNAL_DOMAIN})
```

> **Promtail?** The legacy values (`promtail/`) are kept for reference, but Promtail is deprecated (EOL March 2026) and is replaced here by the OpenTelemetry Collector.

## Components

| Chart | Version | Values | Description |
|---|---|---|---|
| `vm/victoria-metrics-k8s-stack` | 0.25.5 | `victoria-metrics/vm-values.yaml` | VMSingle + vmagent + node-exporter + kube-state-metrics + Grafana |
| `grafana/loki` | 6.7.3 | `loki/loki-values.yaml` | Log storage (single-binary) |
| `open-telemetry/opentelemetry-collector` | 0.165.0 | `otel-collector/otel-values.yaml` | Log collection (DaemonSet) |

## Deployment

Via OpenTofu, see [`DEPLOYMENT-PLAN.md`](../docs/DEPLOYMENT-PLAN.md) phase 2:

```bash
cd tofu/
tofu apply -var deploy_monitoring=true -target='kubernetes_namespace.monitoring[0]'

# Grafana admin Secret (never stored in the repo)
kubectl create secret generic grafana-admin -n monitoring \
  --from-literal=admin-user=admin --from-literal=admin-password='<password>'

tofu apply -var deploy_monitoring=true
```

Storage note: VictoriaMetrics and Grafana use the `nfs-cluster-nolock` StorageClass (created by `tofu/monitoring.tf`). The NFS share is mounted as NFSv3 without a lock manager, so both crash on the plain `nfs-cluster` class with `no locks available`. Loki does not need file locks and stays on `nfs-cluster`.

After changing a values file, re-run `tofu apply` (same flags).

## Verify

```bash
kubectl get pods -n monitoring          # all Running
kubectl get pvc -n monitoring           # vmsingle 8Gi, loki 20Gi, grafana 1Gi : Bound
kubectl logs -n monitoring -l app.kubernetes.io/name=opentelemetry-collector --tail=20
```

Grafana: http://grafana.${INTERNAL_DOMAIN}, then Explore -> Loki -> `{k8s_namespace_name="gitea"}`.

## Scraping an existing app

Annotate the app's **Service**; vmagent discovers it automatically:

```yaml
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"    # port exposing /metrics
  prometheus.io/path: "/metrics"
```

## Pre-installed dashboards

| Dashboard | Grafana ID | Description |
|---|---|---|
| Kubernetes Cluster | 7249 | CPU/RAM/pods overview |
| Node Exporter Full | 1860 | Per-node details |
| K8s Resources Namespace | 13770 | Resources per namespace |
| Loki Logs | 13639 | Log exploration |

## Internal endpoints

- VMSingle: `http://vmsingle-vm.monitoring.svc.cluster.local:8428`
- Loki: `http://loki.monitoring.svc.cluster.local:3100`
- OTLP (to instrument an app): `http://otel-collector.monitoring.svc.cluster.local:4318`

## Teardown

```bash
cd tofu/ && tofu apply -var deploy_monitoring=false
```

> If deleting vm-stack hangs, the admission webhooks are the cause:
> `kubectl delete validatingwebhookconfiguration -l app.kubernetes.io/instance=vm-stack --ignore-not-found`
