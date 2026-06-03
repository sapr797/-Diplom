variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "service_account_key_file" {
  description = "Path to service account key file"
  type        = string
  default     = "key.json"
}

variable "zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "tf-state"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "yc_token" {
  description = "Yandex Cloud IAM token (alternative to service account key)"
  type        = string
  sensitive   = true
  default     = null
}
