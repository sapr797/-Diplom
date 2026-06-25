# VPC Network
resource "yandex_vpc_network" "k8s_network" {
  name        = "${var.cluster_name}-network"
  description = "Network for Kubernetes cluster"
}

# Subnet
resource "yandex_vpc_subnet" "k8s_subnet" {
  name           = "${var.cluster_name}-subnet"
  description    = "Subnet for Kubernetes cluster"
  network_id     = yandex_vpc_network.k8s_network.id
  zone           = var.zone
  v4_cidr_blocks = [var.subnet_cidr]
}
