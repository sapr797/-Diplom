terraform {
  required_version = ">= 1.3"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    region     = "ru-central1"
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
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
}

# VPC Network
resource "yandex_vpc_network" "k8s_network" {
  name        = "k8s-network"
  description = "Network for Kubernetes cluster"
}

# Подсети в разных зонах доступности
resource "yandex_vpc_subnet" "subnets" {
  for_each = var.zones

  name           = "k8s-subnet-${each.key}"
  description    = "Subnet in ${each.key} zone"
  zone           = each.key
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = [each.value.cidr]
}

# Группа безопасности для worker nodes
resource "yandex_vpc_security_group" "k8s_workers" {
  name        = "k8s-workers-sg"
  description = "Security group for Kubernetes worker nodes"
  network_id  = yandex_vpc_network.k8s_network.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "K8s API"
    v4_cidr_blocks = var.k8s_api_allowed_cidrs
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "NodePort services"
    v4_cidr_blocks = var.k8s_api_allowed_cidrs
    port           = 30000
   # to_port        = 32767
  }

  egress {
    protocol       = "ANY"
    description    = "All outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Упрощенный скрипт инициализации (для тестирования)
locals {
  user_data = <<-EOF
    #cloud-config
    packages:
      - docker.io
    package_update: true
    runcmd:
      - systemctl enable docker && systemctl start docker
      - usermod -aG docker ubuntu
  EOF
}

# Worker nodes (прерываемые ВМ)
resource "yandex_compute_instance" "k8s_workers" {
  count = var.worker_count

  name        = "k8s-worker-${count.index + 1}"
  description = "Preemptible worker node for Kubernetes"
  hostname    = "k8s-worker-${count.index + 1}"
  zone        = var.zones_list[count.index % length(var.zones_list)]
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = var.worker_cores
    memory        = var.worker_memory
    core_fraction = var.worker_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.worker_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnets[var.zones_list[count.index % length(var.zones_list)]].id
    nat                = false

    security_group_ids = [yandex_vpc_security_group.k8s_workers.id]
  }

  metadata = {
    user-data = local.user_data
    ssh-keys  = "ubuntu:${file(var.ssh_public_key_path)}"
  }

  scheduling_policy {
    preemptible = true
  }

  labels = {
    environment = "k8s-training"
    node-type   = "worker"
    preemptible = "true"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

output "worker_ips" {
  value = {
    for idx, vm in yandex_compute_instance.k8s_workers :
    idx + 1 => {
      name = vm.name
      ip   = vm.network_interface[0].nat_ip_address
    }
  }
  description = "Public IP addresses of worker nodes"
}

output "network_id" {
  value = yandex_vpc_network.k8s_network.id
  description = "ID of created VPC network"
}

output "subnet_ids" {
  value = {
    for zone, subnet in yandex_vpc_subnet.subnets :
    zone => subnet.id
  }
  description = "IDs of created subnets"
}

# Правило для доступа из compute-vm к k8s сети
resource "yandex_vpc_security_group_rule" "allow_from_compute" {
  security_group_binding = yandex_vpc_security_group.k8s_workers.id
  direction              = "ingress"
  description            = "Allow from compute-vm network"
  protocol               = "ANY"
  v4_cidr_blocks         = ["10.0.1.0/24"]
}
