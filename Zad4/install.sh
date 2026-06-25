#!/bin/bash

set -e

echo " Installing Prometheus + Grafana stack..."

# Проверка helm
if ! command -v helm &> /dev/null; then
    echo "Helm not found. Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Добавление репозитория
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Создание namespace
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Установка
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f values.yaml \
  --wait \
  --timeout 10m

echo ""
echo "✅ Prometheus + Grafana installed!"

# Деплой тестового приложения
echo "Deploying test application..."
kubectl apply -f app/deployment.yaml

echo ""
echo "========================================="
echo " Access URLs:"
echo "========================================="
echo "Grafana: http://<NODE_IP>:30090"
echo "Prometheus: http://<NODE_IP>:30091"
echo "Alertmanager: http://<NODE_IP>:30093"
echo "Test App: http://<NODE_IP>:30080"
echo "========================================="
echo "Grafana Login: admin / admin123"
echo "========================================="

# Получение IP нод
echo ""
echo " Node IPs:"
kubectl get nodes -o wide | awk '{print $1, $7}'
