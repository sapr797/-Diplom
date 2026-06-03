
Zad2: VPC and Compute Instances
Описание
Создание облачной инфраструктуры для Kubernetes кластера:

VPC сеть с 3 подсетями в разных зонах доступности

3 прерываемые ВМ для worker nodes

Группы безопасности

Архитектура
text
k8s-network (10.0.0.0/16)
├── subnet-ru-central1-a (10.1.0.0/24)
├── subnet-ru-central1-b (10.2.0.0/24)
└── subnet-ru-central1-d (10.3.0.0/24)

ВМ:
├── k8s-worker-1 (master) - ru-central1-a
├── k8s-worker-2 - ru-central1-b
└── k8s-worker-3 - ru-central1-d
Параметры ВМ
Платформа: standard-v2

CPU: 2 ядра

RAM: 4 GB

Core fraction: 100%

Disk: 20 GB (network-hdd)

Preemptible: да

Порты
ПортНазначение
22SSH
6443Kubernetes API
30000-32767NodePorts
Запуск
bash
terraform init
terraform plan
terraform apply -auto-approve
Вывод
network_id - ID VPC сети

subnet_ids - ID подсетей

worker_ips - внешние IP worker nodes
