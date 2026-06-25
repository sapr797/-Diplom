cloud_id                 = "b1g36426920rk8dvvn2r"
folder_id                = "b1gsq7mn8r0m1g4qf15j"
yc_token                 = "t1.9euelZrIy8nJzceWx..."
worker_count             = 3
worker_cores             = 2
worker_memory            = 2
worker_core_fraction     = 20
worker_disk_size         = 20
image_id                 = "fd817i7o8012578061ra"
subnet_cidr              = "10.100.0.0/24
zone                     = "ru-central1-a"
ssh_public_key_path      = "~/.ssh/id_ed25519.pub"

zones = {
  "ru-central1-a" = { cidr = "10.1.0.0/24" }
  "ru-central1-b" = { cidr = "10.2.0.0/24" }
  "ru-central1-d" = { cidr = "10.3.0.0/24" }
}

zones_list = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

k8s_api_allowed_cidrs = ["0.0.0.0/0"]
