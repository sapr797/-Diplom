resource "yandex_kubernetes_node_group" "k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "${var.cluster_name}-nodes"

  instance_template {
    platform_id = "standard-v2"

    resources {
      memory        = var.node_memory
      cores         = var.node_cores
      core_fraction = var.node_core_fraction
    }

    boot_disk {
      type = "network-ssd"
      size = var.node_disk_size
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.k8s_subnet.id]
      nat        = true  # Публичный IP для доступа к интернету
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  # Health check
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }

  node_labels = {
    environment = "dev"
    managed-by  = "terraform"
  }
}
