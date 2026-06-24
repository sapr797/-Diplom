# 🚀 Развертывание Managed Kubernetes Кластера в Yandex Cloud

Этот проект содержит конфигурацию **Terraform** для создания полностью управляемого кластера Kubernetes (Managed Kubernetes) в облаке Yandex Cloud. Инфраструктура описана как код (IaC), что обеспечивает воспроизводимость и автоматизацию.

---

## 📋 Задание (кратко)

Цель работы — автоматизировать создание кластера Kubernetes в Yandex Cloud с помощью Terraform.

### Что было сделано:
- Инициализирован и настроен Terraform-проект.
- Созданы конфигурационные файлы для описания инфраструктуры:
  - **Network**: VPC-сеть и подсеть в зоне `ru-central1-a`.
  - **Cluster**: Managed Kubernetes Cluster с публичным доступом к API.
  - **Node Group**: Группа из 2 воркеров с заданными параметрами (2 vCPU, 4 ГБ RAM, 30 ГБ SSD, core_fraction=50%).
- Настроены переменные для гибкости (токен, идентификаторы облака, размеры нод).
- Предусмотрен вывод важной информации (IP-адрес API, команда для получения kubeconfig).

---

## 🛠️ Предварительные требования

Для успешного применения конфигурации вам понадобится:

1. **Учетная запись Yandex Cloud** с активированным биллингом.
2. **Установленный Terraform** (версия >= 1.3).
3. **Установленный Yandex Cloud CLI** (`yc`).
4. **IAM-токен** или ключ сервисного аккаунта для аутентификации.
5. **SSH-ключ** (для доступа к узлам кластера — опционально для управляемого кластера, но рекомендуется).

---

## 📂 Структура проекта

```bash
yc-k8s-cluster/
├── providers.tf          # Конфигурация провайдера Yandex Cloud
├── variables.tf          # Все используемые переменные
├── network.tf            # Создание VPC сети и подсети
├── k8s-cluster.tf        # Управляемый кластер Kubernetes
├── node-group.tf         # Группа worker-узлов
├── outputs.tf            # Вывод информации о созданных ресурсах
├── terraform.tfvars.example  # Пример файла с переменными
└── README.md             # Этот файл
⚙️ Настройка и запуск
1. Клонируйте репозиторий
bash
git clone <url_вашего_репозитория>
cd yc-k8s-cluster
2. Настройте переменные окружения / файл terraform.tfvars
Создайте файл terraform.tfvars на основе примера и заполните его своими данными:

bash
cp terraform.tfvars.example terraform.tfvars
Пример содержимого terraform.tfvars:

hcl
cloud_id  = "b1gXXXXXXXXXXXXX"          # ID вашего облака
folder_id = "b1gsq7mn8r0m1g4qf15j"      # ID вашего каталога
yc_token  = "t1.9euelZrIy8nJzceWx..."   # IAM-токен (yc iam create-token)

zone = "ru-central1-a"

cluster_name        = "k8s-devops-cluster"
cluster_description = "DevOps Kubernetes Cluster"

node_count         = 2
node_disk_size     = 30
node_memory        = 4
node_cores         = 2
node_core_fraction = 50
3. Инициализация Terraform
bash
terraform init
4. Просмотр плана изменений
bash
terraform plan
5. Применение конфигурации
bash
terraform apply -auto-approve
6. Получение kubeconfig для подключения к кластеру
После успешного создания кластера выполните команду:

bash
yc managed-kubernetes cluster get-credentials <имя_кластера> --folder-id <ваш_folder_id>
Или используйте вывод Terraform:

bash
terraform output cluster_endpoint
7. Проверка работоспособности
bash
kubectl get nodes
kubectl get pods -A
📤 Что вы получите на выходе
После выполнения terraform apply Terraform выведет:

Output Name	Описание
cluster_id	Идентификатор кластера
cluster_name	Имя кластера
cluster_endpoint	Публичный адрес API-сервера
cluster_ca_certificate	CA-сертификат (для безопасного подключения)
node_group_id	Идентификатор группы воркеров
node_group_name	Имя группы воркеров
subnet_id	Идентификатор подсети
network_id	Идентификатор VPC сети
🧹 Удаление инфраструктуры
Если кластер больше не нужен, вы можете уничтожить все ресурсы одной командой:

bash
terraform destroy -auto-approve
🔧 Устранение неполадок
Ошибка: Quota vpc.externalAddressesCreation.rate exceeded
Подождите 10–15 минут и повторите terraform apply. Это временное ограничение Yandex Cloud на создание внешних IP-адресов.

Ошибка: Failed to install provider
Проверьте доступ к интернету и права на запись в директорию .terraform.

Используйте зеркало провайдера в ~/.terraformrc:

hcl
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
}
Ошибка: Permission denied при подключении к кластеру
Убедитесь, что у вас установлен kubectl.

Проверьте, что IAM-токен не истек (срок жизни — 12 часов).

📘 Используемые технологии
Terraform (v1.3+) — управление инфраструктурой как кодом.

Yandex Cloud — облачная платформа.

Managed Kubernetes — сервис для запуска Kubernetes-кластеров без управления control plane.

📝 Примечания
Конфигурация создает zonal кластер (один мастер-узел в одной зоне доступности).

При необходимости можно легко изменить количество воркеров, их размер, версию Kubernetes в файле node-group.tf и k8s-cluster.tf.

Ресурсы создаются в рамках квот Yandex Cloud, убедитесь, что они достаточны.

👤 Автор
Имя / Alex
Проект выполнен в рамках учебного задания по курсу DevOps / Cloud Infrastructure.

📄 Лицензия
Этот проект распространяется под лицензией MIT
