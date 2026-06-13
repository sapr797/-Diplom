# Zad4: Система мониторинга (Prometheus + Grafana)

## Установка через Helm

### Предварительные требования
- Установленный Helm 3
- Доступ к Kubernetes кластеру

### Установка kube-prometheus-stack

```bash
# Добавление репозитория
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Создание namespace
kubectl create namespace monitoring

# Установка
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30090 \
  --set grafana.adminPassword=admin123 \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30091
Доступ к сервисам
СервисПортURL
Grafana30090http://<NODE_IP>:30090
Prometheus30091http://<NODE_IP>:30091
Alertmanager30093http://<NODE_IP>:30093
Данные для входа в Grafana
Логин: admin

Пароль: admin123

Удаление
bash
helm uninstall prometheus -n monitoring
kubectl delete namespace monitoring
