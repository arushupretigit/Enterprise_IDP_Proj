variable "cluster_name" {
  description = "Name of the kind cluster"
  type        = string
}

variable "node_image" {
  description = "Optional kindest/node image override"
  type        = string
  default     = null
}

variable "worker_count" {
  description = "Number of worker nodes to provision"
  type        = number
  default     = 2

  validation {
    condition     = var.worker_count >= 1
    error_message = "worker_count must be at least 1 for a multi-node setup."
  }
}

variable "extra_port_mappings" {
  description = "Host-to-control-plane port mappings for Ingress/HTTP/HTTPS access"
  type = list(object({
    container_port = number
    host_port      = number
    protocol       = optional(string, "TCP")
  }))
  default = []
}