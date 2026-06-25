
#  Задание 3: Тестовое приложение

##  Описание

Создание тестового приложения на базе nginx для демонстрации работы Kubernetes кластера.

### Что сделано:
- ✅ Создан отдельный git репозиторий с тестовым приложением
- ✅ Подготовлен Dockerfile для сборки образа
- ✅ Настроен nginx для отдачи статических данных
- ✅ Создан манифест для деплоя в Kubernetes
- ✅ Подготовлена конфигурация для Yandex Container Registry

---

##  Структура репозитория
test-app/
├── Dockerfile # Сборка образа
├── index.html # Статическая страница
├── deployment.yaml # Kubernetes манифест
├── .dockerignore # Исключения для сборки
└── README.md # Документация


---

##  Файлы

### 1. `Dockerfile`

```dockerfile
FROM nginx:alpine

# Копируем статическую страницу
COPY index.html /usr/share/nginx/html/index.html

# Копируем кастомный конфиг nginx (опционально)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Запуск nginx в foreground
CMD ["nginx", "-g", "daemon off;"]

Сборка и публикация
1. Сборка образа
bash
# Локальная сборка
docker build -t test-app:latest .

# Тестирование
docker run -p 8080:80 test-app:latest
# Открыть http://localhost:8080
2. Публикация в Yandex Container Registry
bash
# Аутентификация в YCR
yc container registry configure-docker

# Создать реестр (если не создан)
yc container registry create --name test-app

# Получить ID реестра
export REGISTRY_ID=$(yc container registry list --format json | jq -r '.[0].id')

# Тегирование образа
docker tag test-app:latest cr.yandex/$REGISTRY_ID/test-app:latest
docker tag test-app:latest cr.yandex/$REGISTRY_ID/test-app:v1.0.0

# Публикация
docker push cr.yandex/$REGISTRY_ID/test-app:latest
docker push cr.yandex/$REGISTRY_ID/test-app:v1.0.0
3. Terraform для Container Registry (опционально)
hcl
# registry.tf
resource "yandex_container_registry" "test_app" {
  name      = "test-app"
  folder_id = var.folder_id
  labels = {
    environment = "dev"
    managed-by  = "terraform"
  }
}

output "registry_id" {
  value = yandex_container_registry.test_app.id
}

output "registry_name" {
  value = yandex_container_registry.test_app.name
}

