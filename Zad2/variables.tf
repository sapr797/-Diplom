# Общие
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

variable "service_account_key_file" {
  description = "Path to service account key file"
  type        = string
  default     = "../01-setup/key.json"
}

# Сеть
variable "zones" {
  description = "Availability zones with CIDR blocks"
  type = map(object({
    cidr = string
  }))
  default = {
    "ru-central1-a" = { cidr = "10.1.0.0/24" }
    "ru-central1-b" = { cidr = "10.2.0.0/24" }
    "ru-central1-d" = { cidr = "10.3.0.0/24" }
  }
}

variable "zones_list" {
  description = "List of zones for distribution"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
  default     = "k8s-network"
}

# Кластер
variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "k8s-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "k8s_api_allowed_cidrs" {
  description = "CIDRs allowed to access Kubernetes API"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Worker nodes
variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

variable "worker_cores" {
  description = "CPU cores per worker"
  type        = number
  default     = 2
}

variable "worker_memory" {
  description = "Memory (GB) per worker"
  type        = number
  default     = 2
}

variable "worker_core_fraction" {
  description = "Guaranteed vCPU share"
  type        = number
  default     = 20
}

variable "worker_disk_size" {
  description = "Disk size (GB) per worker"
  type        = number
  default     = 20
}

variable "preemptible" {
  description = "Use preemptible VMs for workers"
  type        = bool
  default     = true
}

# SSH
variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Образ
variable "image_id" {
  description = "Ubuntu 22.04 LTS image ID"
  type        = string
  default     = "fd80ok8sil1fn2gqbm6h"
}

# Backend
variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "tf-state-k8s"
}
