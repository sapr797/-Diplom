cloud_id                 = "b1g36426920rk8dvvn2r"
folder_id                = "b1gsq7mn8r0m1g4qf15j"
service_account_key_file = "key.json"
zone                     = "ru-central1-a"

cluster_name        = "k8s-devops-cluster"
cluster_description = "DevOps Kubernetes Cluster"

node_count         = 2
node_disk_size     = 30
node_memory        = 4
node_cores         = 2
node_core_fraction = 50

ssh_public_key_path = "~/.ssh/id_ed25519.pub"
