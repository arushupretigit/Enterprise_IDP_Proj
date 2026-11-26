module "prod_cluster" {
  source       = "../../modules/kind_cluster"
  cluster_name = "idp-prod"
  worker_count = 2

  extra_port_mappings = [
    {
      container_port = 80
      host_port      = 8081
      protocol       = "TCP"
    },
    {
      container_port = 443
      host_port      = 8444
      protocol       = "TCP"
    }
  ]
}

module "prod_baseline" {
  source = "../../modules/cluster_baseline"

  environment   = "prod"
  app_namespace = "app-prod"

  cpu_quota_limit    = "4"
  memory_quota_limit = "4Gi"

  depends_on = [module.prod_cluster]
}