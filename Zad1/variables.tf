# Cоздания сервисного аккаунта и S3 бакета
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

# Переменные для сервисного аккаунта
variable "service_account_name" {
  description = "Name of the service account"
  type        = string
  default     = "terraform-sa"
}

variable "service_account_description" {
  description = "Description of the service account"
  type        = string
  default     = "Service account for Terraform operations"
}

# Переменные для S3 бакета
variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "tf-state"
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "bucket_max_size" {
  description = "Maximum size of the bucket in bytes"
  type        = number
  default     = 1073741824 # 1 GB
}
