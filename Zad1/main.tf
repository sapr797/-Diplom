terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.92"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

# Генерация случайного суффикса для уникальности имени бакета
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  bucket_name = "${var.bucket_name_prefix}-${var.environment}-${random_string.bucket_suffix.result}"
}

# S3 бакет для хранения Terraform state
resource "yandex_storage_bucket" "tf_state" {
  bucket   = local.bucket_name
  max_size = 1073741824 # 1 GB
  
  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "cleanup-old-versions"
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "State storage"
  }
}

# Вывод информации
output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = yandex_storage_bucket.tf_state.bucket
}

output "bucket_tags" {
  description = "Tags of the created bucket"
  value       = yandex_storage_bucket.tf_state.tags
}
