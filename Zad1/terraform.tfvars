cloud_id                 = var.cloud_id
folder_id                = var.folder_id
service_account_key_file = var.service_account_key_file
zone                     = var.zone

cluster_name        = "k8s-devops-cluster"
cluster_description = "DevOps Kubernetes Cluster"

node_count         = 2
node_disk_size     = 30
node_memory        = 4
node_cores         = 2
node_core_fraction = 50

subnet_cidr = "10.100.0.0/24"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"
