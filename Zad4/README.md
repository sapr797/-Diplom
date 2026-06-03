
Zad4: Мониторинг (Prometheus + Grafana)
Описание
Установка системы мониторинга для Kubernetes кластера.

Компоненты
Prometheus - сбор метрик

Grafana - визуализация

Alertmanager - оповещения

Node Exporter - метрики узлов

kube-state-metrics - метрики Kubernetes

Установка через Helm
bash
# Добавление репозитория
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Установка
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
Доступ к Grafana
bash
# Проброс порта
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Логин: admin
# Пароль: prom-operator
Доступ к Prometheus
bash
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
Предустановленные дашборды
Kubernetes Cluster

Kubernetes Nodes

Kubernetes Pods

Kubernetes API Server

CoreDNS
