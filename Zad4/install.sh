#!/bin/bash

echo "Installing Prometheus + Grafana stack..."

# Проверка наличия helm
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
  -f values.yaml

echo ""
echo "========================================="
echo "Prometheus + Grafana installed!"
echo "========================================="
echo "Grafana: http://<NODE_IP>:30090"
echo "Username: admin"
echo "Password: admin123"
echo "========================================="
