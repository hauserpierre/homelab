# Values files and manifests are shared with the manual workflow
# (scripts/render.sh + helm/kubectl), so they use ${VAR} placeholders instead
# of templatefile() syntax. local.render holds each file with the placeholders
# replaced by the matching variables.

locals {
  rendered_files = {
    gitea           = "../gitea/gitea-values.yaml"
    immich          = "../immich/values.yaml"
    nfs_provisioner = "values/nfs-provisioner.yaml"
    victoria        = "../monitoring/victoria-metrics/vm-values.yaml"
    loki            = "../monitoring/loki/loki-values.yaml"
    otel            = "../monitoring/otel-collector/otel-values.yaml"
    authentik       = "values/authentik.yaml"
    teleport        = "values/teleport.yaml"
    teleport_route  = "manifests/teleport-ingressroutetcp.yaml"
  }

  render = {
    for name, rel in local.rendered_files : name => replace(replace(replace(replace(
      file("${path.module}/${rel}"),
      "$${INTERNAL_DOMAIN}", var.internal_domain),
      "$${PUBLIC_DOMAIN}", var.public_domain),
      "$${NODE_IP}", var.node_ip),
    "$${NFS_SERVER_IP}", var.nfs_server_ip)
  }
}
