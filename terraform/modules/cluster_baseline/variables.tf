variable "environment" {
  description = "Target environment name (e.g., dev, prod)"
  type        = string
}

variable "platform_namespaces" {
  description = "List of platform namespaces to create"
  type        = list(string)
  default     = ["argocd", "kyverno", "argo-rollouts", "monitoring"]
}

variable "app_namespace" {
  description = "Primary application namespace for this environment"
  type        = string
}

variable "cpu_quota_limit" {
  description = "Total CPU limit allowed in the application namespace"
  type        = string
  default     = "4"
}

variable "memory_quota_limit" {
  description = "Total memory limit allowed in the application namespace"
  type        = string
  default     = "4Gi"
}

variable "default_cpu_request" {
  description = "Default container CPU request when omitted"
  type        = string
  default     = "100m"
}

variable "default_cpu_limit" {
  description = "Default container CPU limit when omitted"
  type        = string
  default     = "500m"
}

variable "default_memory_request" {
  description = "Default container memory request when omitted"
  type        = string
  default     = "128Mi"
}

variable "default_memory_limit" {
  description = "Default container memory limit when omitted"
  type        = string
  default     = "512Mi"
}