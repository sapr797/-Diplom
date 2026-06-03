
Zad3: Тестовое приложение
Описание
Развертывание тестового nginx приложения в Kubernetes кластере.

Файлы
deployment.yaml - манифесты Deployment и Service

Приложение
Образ: nginx:alpine

Порт: 80

Тип сервиса: NodePort

NodePort: 31160

Развертывание
bash
kubectl apply -f deployment.yaml
Проверка
bash
# Статус подов
kubectl get pods

# Статус сервиса
kubectl get svc

# Доступ к приложению
curl http://<ANY_NODE_IP>:31160
Деплой в кластер
bash
# Установка
kubectl apply -f deployment.yaml

# Удаление
kubectl delete -f deployment.yaml
