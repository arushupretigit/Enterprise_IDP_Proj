resource "kubernetes_namespace" "platform" {
  for_each = toset(var.platform_namespaces)

  metadata {
    name = each.value
    labels = {
      "environment" = var.environment
      "managed-by"  = "terraform"
      "tier"        = "platform"
    }
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
    labels = {
      "environment" = var.environment
      "managed-by"  = "terraform"
      "tier"        = "application"
    }
  }
}

resource "kubernetes_service_account" "app_workload" {
  metadata {
    name      = "idp-sample-service-sa"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      "environment" = var.environment
      "managed-by"  = "terraform"
    }
  }
}

# Least-privilege namespace-scoped role (e.g., reading ConfigMaps/Secrets/Pods in app namespace)
resource "kubernetes_role" "app_reader" {
  metadata {
    name      = "idp-app-reader"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      "environment" = var.environment
      "managed-by"  = "terraform"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "configmaps", "services"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "app_workload_reader" {
  metadata {
    name      = "idp-app-workload-reader-binding"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      "environment" = var.environment
      "managed-by"  = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.app_reader.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.app_workload.metadata[0].name
    namespace = kubernetes_namespace.app.metadata[0].name
  }
}

resource "kubernetes_limit_range" "app_defaults" {
  metadata {
    name      = "idp-app-limit-range"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = var.default_cpu_limit
        memory = var.default_memory_limit
      }
      default_request = {
        cpu    = var.default_cpu_request
        memory = var.default_memory_request
      }
    }
  }
}

resource "kubernetes_resource_quota" "app_quota" {
  metadata {
    name      = "idp-app-resource-quota"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    hard = {
      "limits.cpu"    = var.cpu_quota_limit
      "limits.memory" = var.memory_quota_limit
      "pods"          = "20"
    }
  }

  depends_on = [kubernetes_limit_range.app_defaults]
}