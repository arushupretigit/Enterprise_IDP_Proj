module "dev_cluster" {
  source       = "../../modules/kind_cluster"
  cluster_name = "idp-dev"
  worker_count = 1

  extra_port_mappings = [
    {
      container_port = 80
      host_port      = 8080
      protocol       = "TCP"
    },
    {
      container_port = 443
      host_port      = 8443
      protocol       = "TCP"
    }
  ]
}

module "dev_baseline" {
  source = "../../modules/cluster_baseline"

  environment   = "dev"
  app_namespace = "app-dev"

  cpu_quota_limit    = "4"
  memory_quota_limit = "4Gi"

  depends_on = [module.dev_cluster]
}