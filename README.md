
DevOps Diplom Project
Проект
Развертывание Kubernetes кластера в Yandex Cloud с полным CI/CD пайплайном.

Структура
text
├── Zad1/ - Terraform: Service Account + S3 bucket
├── Zad2/ - Terraform: VPC + 3 VMs
├── Zad3/ - Kubernetes: nginx application
├── Zad4/ - Monitoring: Prometheus + Grafana
└── Zad5/ - CI/CD: GitHub Actions pipeline
Требования
Yandex Cloud аккаунт

Terraform >= 1.3

kubectl >= 1.28

Helm >= 3.0

Запуск инфраструктуры
1. Service Account и S3 bucket
bash
cd Zad1
terraform init
terraform apply -auto-approve
2. VPC и ВМ
bash
cd Zad2
terraform init
terraform apply -auto-approve
3. Kubernetes кластер
bash
# Инициализация master
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Присоединение worker нод
sudo kubeadm join <master-ip>:6443 --token <token>
4. Деплой приложения
bash
kubectl apply -f Zad3/deployment.yaml
5. Мониторинг
bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
Результаты
✅ Kubernetes кластер (3 ноды)

✅ Тестовое приложение (nginx)

✅ Мониторинг (Prometheus + Grafana)

✅ CI/CD пайплайн (GitHub Actions)

Автор
sapr797

Лицензия
MIT
