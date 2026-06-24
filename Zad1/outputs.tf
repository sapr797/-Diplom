output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.name
}

output "cluster_endpoint" {
  description = "API endpoint of the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.master.0.external_v4_endpoint
}

output "cluster_ca_certificate" {
  description = "CA certificate for the Kubernetes cluster"
  value       = yandex_kubernetes_cluster.k8s_cluster.master.0.cluster_ca_certificate
  sensitive   = true
}

output "node_group_id" {
  description = "ID of the node group"
  value       = yandex_kubernetes_node_group.k8s_nodes.id
}

output "node_group_name" {
  description = "Name of the node group"
  value       = yandex_kubernetes_node_group.k8s_nodes.name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = yandex_vpc_subnet.k8s_subnet.id
}

output "network_id" {
  description = "ID of the VPC network"
  value       = yandex_vpc_network.k8s_network.id
}
