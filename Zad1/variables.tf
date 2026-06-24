variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "yc_token" {
  description = "Yandex Cloud IAM token"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "k8s-cluster"
}

variable "cluster_description" {
  description = "Description of the Kubernetes cluster"
  type        = string
  default     = "Managed Kubernetes cluster"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "node_disk_size" {
  description = "Size of node disk in GB"
  type        = number
  default     = 30
}

variable "node_memory" {
  description = "Memory for each node in GB"
  type        = number
  default     = 4
}

variable "node_cores" {
  description = "CPU cores for each node"
  type        = number
  default     = 2
}

variable "node_core_fraction" {
  description = "Core fraction for nodes (20, 50, 100)"
  type        = number
  default     = 50
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.100.0.0/24"
}
