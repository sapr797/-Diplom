#  Zad4: Система мониторинга (Prometheus + Grafana)

##  Описание

Установка и настройка системы мониторинга для Kubernetes кластера на базе **kube-prometheus-stack**, включающей:
- **Prometheus** — сбор метрик
- **Grafana** — визуализация
- **Alertmanager** — оповещения
- **Node Exporter** — метрики нод
- **kube-state-metrics** — состояние кластера

---

## Структура
Zad4/
├── README.md # Документация
├── install.sh # Скрипт установки
├── uninstall.sh # Скрипт удаления
├── values.yaml # Кастомная конфигурация
└── monitoring.yaml # Пример установки
---

##  Предварительные требования

- ✅ **Helm 3** установлен
- ✅ **kubectl** настроен на кластер
- ✅ **Доступ** к Kubernetes кластеру

### Проверка:

```
# Проверить Helm
helm version

# Проверить kubectl
kubectl get nodes

# Проверить доступ к кластеру
kubectl cluster-info
 Установка
Способ 1: Быстрая установка через скрипт

cd Zad4
chmod +x install.sh
./install.sh
Способ 2: Ручная установка

# 1. Добавить репозиторий
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2. Создать namespace
kubectl create namespace monitoring

# 3. Установить стек
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f values.yaml \
  --wait

# 4. Проверить установку
kubectl get pods -n monitoring
Способ 3: Установка с параметрами командной строки

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30090 \
  --set grafana.adminPassword=admin123 \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30091 \
  --set alertmanager.service.type=NodePort \
  --set alertmanager.service.nodePort=30093 \
  --wait
 Доступ к сервисам
Сервис	Порт	URL	Данные для входа
Grafana	30090	http://<NODE_IP>:30090	admin / admin123
Prometheus	30091	http://<NODE_IP>:30091	—
Alertmanager	30093	http://<NODE_IP>:30093	—
Как получить Node IP:

# Получить внешний IP ноды
kubectl get nodes -o wide | awk '{print $1, $7}'

# Или через Yandex CLI
yc compute instance list --folder-id <folder_id>
 Дашборды в Grafana
После установки доступны стандартные дашборды:

Kubernetes / Compute Resources / Namespace (Pods)
CPU и Memory по подам

Сетевой трафик

Статус подов

Kubernetes / Compute Resources / Cluster
Общее состояние кластера

Использование ресурсов

Количество подов/нод

Node Exporter / Nodes
CPU, RAM, Disk, Network

Температура и нагрузка

Kubernetes / Persistent Volumes
Статус томов

Использование хранилища

Кастомизация
Изменение пароля Grafana

# Через values.yaml
grafana:
  adminPassword: your_new_password

# Или через параметры
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --set grafana.adminPassword=your_new_password
Изменение портов

# В values.yaml
grafana:
  service:
    type: NodePort
    nodePort: 30090

# Или через параметры
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --set grafana.service.nodePort=30090
Настройка хранения данных

# values.yaml
prometheus:
  prometheusSpec:
    storageSpec:
      volumeClaimTemplate:
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: "10Gi"

grafana:
  persistence:
    enabled: true
    size: "5Gi"
 Alertmanager
Просмотр алертов

# Прокси к Alertmanager
kubectl port-forward -n monitoring svc/prometheus-alertmanager 9093:9093

# Открыть http://localhost:9093
Настройка уведомлений

# values.yaml
alertmanager:
  config:
    global:
      resolve_timeout: "5m"
    route:
      group_by: ["alertname", "namespace"]
      group_wait: "30s"
      group_interval: "5m"
      repeat_interval: "4h"
      receiver: "default"
    receivers:
    - name: "default"
      webhook_configs:
      - url: "http://your-webhook-url/webhook"
🔍 Проверка работы
Проверка всех подов

kubectl get pods -n monitoring

# Ожидаемый вывод:
# NAME                                               READY   STATUS    RESTARTS   AGE
# prometheus-grafana-xxxxx                           2/2     Running   0          5m
# prometheus-kube-state-metrics-xxxxx               1/1     Running   0          5m
# prometheus-prometheus-node-exporter-xxxxx         1/1     Running   0          5m
# prometheus-alertmanager-xxxxx                      2/2     Running   0          5m
# prometheus-prometheus-xxxxx                        2/2     Running   0          5m
Проверка сервисов

kubectl get svc -n monitoring

# Проверить NodePort
kubectl get svc -n monitoring prometheus-grafana -o yaml | grep nodePort
Проверка эндпоинтов

# Проверить соединение с Grafana
curl -v http://<NODE_IP>:30090

# Проверить соединение с Prometheus
curl -v http://<NODE_IP>:30091

# Проверить соединение с Alertmanager
curl -v http://<NODE_IP>:30093
 Удаление
Способ 1: Через скрипт

cd Zad4
chmod +x uninstall.sh
./uninstall.sh
Способ 2: Вручную

# Удалить Helm релиз
helm uninstall prometheus -n monitoring

# Удалить namespace
kubectl delete namespace monitoring
Способ 3: Полное удаление с Persistent Volumes

# Удалить релиз
helm uninstall prometheus -n monitoring

# Удалить namespace
kubectl delete namespace monitoring

# Удалить Persistent Volumes (если есть)
kubectl get pv | grep monitoring | awk '{print $1}' | xargs kubectl delete pv

Устранение неполадок
Ошибка: Helm не найден

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
Ошибка: Pods в статусе Pending

# Проверить состояние
kubectl describe pod -n monitoring <pod-name>

# Проверить PersistentVolumeClaims
kubectl get pvc -n monitoring

# Если проблема с PVC, удалить и пересоздать
kubectl delete pvc -n monitoring <pvc-name>
Ошибка: Доступ к Grafana

# Проверить, что сервис работает
kubectl get svc -n monitoring prometheus-grafana

# Проверить порт
kubectl get svc -n monitoring prometheus-grafana -o yaml | grep nodePort

# Попробовать через port-forward
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
# Доступ: http://localhost:3000
 Скриншоты для отчета
1. Все поды в namespace monitoring

kubectl get pods -n monitoring
Скриншот: Все поды в статусе Running

2. Графики в Grafana
Скриншот: Дашборд Kubernetes / Compute Resources / Cluster

3. Доступ к приложению
Скриншот: http://<NODE_IP>:30090 — Grafana Login Page

Полезные ссылки
kube-prometheus-stack GitHub

Grafana Dashboards

Prometheus Documentation

Yandex Cloud Managed Kubernetes

✅ Итог
✅ Prometheus для сбора метрик
✅ Grafana с дашбордами (порт 30090)
✅ Alertmanager для оповещений
✅ Node Exporter для метрик нод
✅ kube-state-metrics для состояния кластера

Проверка:
# Статус всех подов
kubectl get pods -A

# Доступ к Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Доступ к Prometheus
kubectl port-forward -n monitoring svc/prometheus-prometheus 9090:9090
Grafana доступна по http://localhost:3000! 🚀
