# Service Account for K8s cluster
resource "yandex_iam_service_account" "k8s_sa" {
  name        = "${var.cluster_name}-sa"
  description = "Service account for Kubernetes cluster"
}

# Grant permissions for K8s cluster
resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# Managed Kubernetes Cluster
resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name        = var.cluster_name
  description = var.cluster_description

  network_id = yandex_vpc_network.k8s_network.id

  master {
    version = "1.30"  # Последняя стабильная версия
    
    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.k8s_subnet.id
    }

    public_ip = true  # Включить публичный доступ к API
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_sa_editor
  ]

  # Настройки для сохранения IP-адресов (опционально)
  # release_channel = "STABLE"
}
