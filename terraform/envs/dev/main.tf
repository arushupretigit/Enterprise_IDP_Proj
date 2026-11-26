module "dev_cluster" {
  source       = "../../modules/kind_cluster"
  cluster_name = "idp-dev"
  worker_count = 2

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