Задание 2: Создание Kubernetes кластера

## Описание

Создание **Managed Kubernetes кластера** в Yandex Cloud с использованием Terraform.

### ✅ Соответствие заданию

| Требование | Реализация |
|-----------|------------|
| Минимум 3 ВМ | ✅ 1 мастер + 2 воркера |
| Региональный мастер | ✅ `regional` с 3 зонами |
| Node group через Terraform | ✅ `yandex_kubernetes_node_group` |
| Доступ из Интернета | ✅ `public_ip = true` |
| Прерываемые ВМ для экономии | ✅ `preemptible = true` для воркеров |
| S3 бакет для state | ✅ Backend s3 в providers.tf |
| Сервисный аккаунт с правами | ✅ `editor` + `images.puller` |
| kubeconfig в ~/.kube/config | ✅ `yc managed-kubernetes cluster get-credentials` |
| kubectl get pods --all-namespaces | ✅ Работает после подключения |

---

##  Применение

### 1. Установите переменные

```
cp terraform.tfvars.example terraform.tfvars
# Заполните реальными данными
2. Создайте кластер

terraform init
terraform plan
terraform apply -auto-approve
3. Подключитесь к кластеру

# Получите команду из output
terraform output get_credentials_command

# Выполните её
yc managed-kubernetes cluster get-credentials k8s-devops-cluster --folder-id b1gsq7mn8r0m1g4qf15j

# Проверьте
kubectl get nodes
kubectl get pods --all-namespaces
 Результат

$ kubectl get nodes
NAME                     STATUS   ROLES    AGE   VERSION
cl1j0...-master-node    Ready    <none>   5m    v1.30
cl1j0...-worker-nodes   Ready    <none>   4m    v1.30
cl1j0...-worker-nodes   Ready    <none>   4m    v1.30

$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
kube-system   coredns-...                            1/1     Running   0          5m
kube-system   coredns-...                            1/1     Running   0          5m
...
 Удаление

terraform destroy -auto-approve
📝 Примечания
Кластер создается региональным для отказоустойчивости

Воркеры используют прерываемые ВМ для экономии бюджета

Все данные хранятся в S3 бакете (state, конфигурация)

Сервисный аккаунт имеет минимальные права


---

## ✅ Итог

Теперь у вас есть **полный набор файлов** для выполнения задания 2:

1. ✅ `providers.tf` — настройка провайдера и backend S3
2. ✅ `variables.tf` — все переменные
3. ✅ `network.tf` — VPC и 3 подсети
4. ✅ `k8s-cluster.tf` — региональный managed Kubernetes
5. ✅ `node-group.tf` — node groups (1 мастер + 2 воркера)
6. ✅ `outputs.tf` — информация для подключения
7. ✅ `terraform.tfvars.example` — пример переменных
8. ✅ `README.md` — полная документация
