terraform {
  required_version = ">= 1.3"
  
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tf-state-k8s"  # Замените на ваш бакет из задания 1
    region     = "ru-central1"
    key        = "cluster/terraform.tfstate"
    access_key = ""  # Будут взяты из переменных окружения
    secret_key = ""  # Будут взяты из переменных окружения
    skip_region_validation      = true
    skip_credentials_validation = true
  }

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.92"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
