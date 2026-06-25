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

output "worker_internal_ips" {
  value = {
    for idx, vm in yandex_compute_instance.k8s_workers :
    idx + 1 => {
      name = vm.name
      ip   = vm.network_interface[0].ip_address
    }
  }
  description = "Internal IP addresses of worker nodes"
}

output "network_id" {
  value       = yandex_vpc_network.k8s_network.id
  description = "ID of created VPC network"
}

output "subnet_ids" {
  value = {
    for zone, subnet in yandex_vpc_subnet.subnets :
    zone => subnet.id
  }
  description = "IDs of created subnets"
}

output "security_group_id" {
  value       = yandex_vpc_security_group.k8s_workers.id
  description = "ID of security group"
}
