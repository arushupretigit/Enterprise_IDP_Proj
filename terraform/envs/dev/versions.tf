terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.13.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  host                   = module.dev_cluster.endpoint
  client_certificate     = module.dev_cluster.client_certificate
  client_key             = module.dev_cluster.client_key
  cluster_ca_certificate = module.dev_cluster.cluster_ca_certificate
}