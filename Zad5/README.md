# Задание 5: CI/CD Pipeline

## Описание

Настройка автоматического CI/CD пайплайна для сборки и деплоя приложения при изменениях в репозитории.

### Цель:
- ✅ Автоматическая сборка Docker образа при коммите в main
- ✅ Автоматическая публикация в Yandex Container Registry
- ✅ Автоматический деплой в Kubernetes кластер
- ✅ Проверка через Pull Request
- ✅ Terraform Plan при создании PR
- ✅ Terraform Apply при merge в main

---

## Структура проекта
Zad5/
├── .github/
│ └── workflows/
│ ├── deploy.yml # Основной пайплайн (build → push → deploy)
│ ├── terraform-plan.yml # Plan при создании PR
│ └── terraform-apply.yml # Apply при merge в main
├── scripts/
│ ├── build.sh # Локальная сборка образа
│ ├── push.sh # Публикация в YCR
│ └── deploy.sh # Деплой в K8s
├── k8s/
│ ├── deployment.yaml # Деплой приложения
│ └── service.yaml # Сервис NodePort
└── README.md # Документация

---

## Описание файлов

### 1. GitHub Actions Workflows

#### `deploy.yml` — основной пайплайн
- **Триггеры**:
  - Push в ветку `main` (при изменении Zad3, Zad4, Zad5)
  - Pull Request в `main` (для проверки сборки)

- **Jobs**:
  1. **Build and Push** (только для push в main):
     - Собирает Docker образ с использованием Buildx
     - Использует кэширование через GitHub Actions cache
     - Публикует в Yandex Container Registry с тегами:
       - `latest`
       - `{sha}` (коммит хеш)
     - Выводит информацию о собранном образе

  2. **Deploy to Kubernetes** (только для push в main):
     - Настраивает kubectl
     - Загружает kubeconfig из Secrets
     - Обновляет тег образа в deployment
     - Применяет манифесты в кластер
     - Ожидает готовности деплоя (timeout: 5 минут)
     - Проверяет статус подов и сервисов

  3. **Terraform Plan** (только для Pull Request):
     - Выполняет `terraform plan` для Zad1 и Zad2
     - Комментирует PR с результатами плана
     - Позволяет увидеть изменения до применения

#### `terraform-plan.yml` — план инфраструктуры
- **Триггеры**: Pull Request в `main` (при изменении Zad1, Zad2)
- **Что делает**:
  - Инициализирует Terraform для Zad1 и Zad2
  - Выполняет `terraform plan` с выводом в PR
  - Показывает, какие ресурсы будут созданы/изменены/удалены

#### `terraform-apply.yml` — применение инфраструктуры
- **Триггеры**: Push в `main` (при изменении Zad1, Zad2)
- **Что делает**:
  - Применяет Terraform для Zad1 (создание SA и бакета)
  - Получает backend конфигурацию из Zad1
  - Применяет Terraform для Zad2 с использованием backend
  - Получает kubeconfig и сохраняет для дальнейшего использования
  - Деплоит мониторинг (Zad4) и тестовое приложение (Zad3)

---

### 2. Скрипты для локального запуска

#### `build.sh`
- **Назначение**: Локальная сборка Docker образа
- **Параметры**:
  - `$1` — тег образа (по умолчанию `latest`)
- **Процесс**:
  1. Получает ID реестра из Yandex Cloud
  2. Собирает образ из `Zad3/` с тегом
  3. Выводит информацию о собранном образе

#### `push.sh`
- **Назначение**: Публикация образа в Yandex Container Registry
- **Параметры**:
  - `$1` — тег образа (по умолчанию `latest`)
- **Процесс**:
  1. Аутентифицируется в YCR через `yc container registry configure-docker`
  2. Публикует образ с указанным тегом
  3. Выводит информацию о публикации

#### `deploy.sh`
- **Назначение**: Деплой приложения в Kubernetes
- **Процесс**:
  1. Применяет ConfigMap
  2. Применяет Deployment
  3. Применяет Service
  4. Ожидает готовности деплоя
  5. Выводит URL для доступа к приложению

---

### 3. Kubernetes манифесты

#### `deployment.yaml`
- **Ресурсы**:
  - 2 реплики для отказоустойчивости
  - Контейнер на базе nginx:alpine
  - Порт 80
- **Probes**:
  - Readiness Probe: проверка `/health` через 5 секунд, каждые 10 секунд
  - Liveness Probe: проверка `/health` через 15 секунд, каждые 20 секунд
- **Ресурсы**:
  - Requests: 64Mi RAM, 50m CPU
  - Limits: 128Mi RAM, 100m CPU
- **Образ**: `cr.yandex/REGISTRY_ID/test-app:latest` (обновляется при деплое)

#### `service.yaml`
- **Тип**: NodePort
- **Порт**: 80 → 30080
- **Селектор**: app: test-app
- **Используется** для доступа к приложению извне кластера

---

### 4. Docker

#### `Dockerfile`
- **Базовый образ**: `nginx:alpine` (легкий, ~5MB)
- **Содержимое**:
  - Копирует `index.html` в `/usr/share/nginx/html/`
  - Копирует `nginx.conf` (опционально)
- **Порт**: 80
- **Запуск**: `nginx -g daemon off;`

#### `index.html`
- Современный дизайн с градиентным фоном
- Отображает название проекта, статус, версию
- Показывает время деплоя через JavaScript
- Адаптивная верстка

#### `.dockerignore`
- Исключает: .git, .github, README.md, *.md, .vscode, .idea

---

## Настройка Secrets в GitHub

### Необходимые Secrets:

| Secret | Описание | Как получить |
|--------|----------|--------------|
| `YC_TOKEN` | IAM токен | `yc iam create-token` |
| `YC_SA_KEY` | JSON ключ сервисного аккаунта | Скачать из консоли Yandex Cloud |
| `CLOUD_ID` | ID облака | `yc config list` |
| `FOLDER_ID` | ID каталога | `yc config list` |
| `REGISTRY_ID` | ID Container Registry | `yc container registry list` |
| `KUBE_CONFIG` | kubeconfig (base64) | `cat ~/.kube/config \| base64 -w 0` |

### Добавление Secrets в GitHub:

1. Перейдите в репозиторий → **Settings** → **Secrets and variables** → **Actions**
2. Нажмите **New repository secret**
3. Введите имя и значение секрета

### Команды для получения значений:

```
# Получить kubeconfig в base64
cat ~/.kube/config | base64 -w 0

# Получить IAM токен
yc iam create-token

# Получить ID реестра
yc container registry list

# Получить Cloud ID и Folder ID
yc config list

Процесс работы
Обычный коммит в main
Разработчик делает push в ветку main

GitHub Actions:
Собирает Docker образ с тегами latest и {sha}
Публикует образ в YCR
Обновляет deployment с новым тегом
Выполняет terraform apply для Zad1 и Zad2 (если изменены)
Деплоит мониторинг и приложение
Pull Request
Создается PR в main

GitHub Actions:
Собирает Docker образ (без публикации)
Выполняет terraform plan для Zad1 и Zad2
Комментирует PR с результатами плана
Позволяет увидеть изменения до применения

Релиз (создание тега)
Создается тег v1.0.0

GitHub Actions:
Собирает образ с тегом v1.0.0
Публикует в YCR
Создает GitHub Release
Обновляет deployment

 Доступ к сервисам
Сервис	URL	Данные для входа
Тестовое приложение	http://<NODE_IP>:30080	—
Grafana	http://<NODE_IP>:30090	admin / admin123
Prometheus	http://<NODE_IP>:30091	—
Alertmanager	http://<NODE_IP>:30093	—
Как получить Node IP:

# Получить внешний IP ноды
kubectl get nodes -o wide | awk '{print $1, $7}'

# Или через Yandex CLI
yc compute instance list --folder-id <folder_id>
Проверка работы
После успешного деплоя:
bash
# Проверить поды
kubectl get pods -n default

# Проверить сервисы
kubectl get svc -n default

# Проверить доступ к приложению
kubectl port-forward svc/test-app 8080:80

# Открыть http://localhost:8080

# Проверить health-эндпоинт
curl http://<NODE_IP>:30080/health

# Проверить версию
curl http://<NODE_IP>:30080/version
Проверка логов:

# Логи приложения
kubectl logs -l app=test-app

# Логи конкретного пода
kubectl logs <pod-name>

# Следить за логами в реальном времени
kubectl logs -f -l app=test-app
Устранение неполадок
Проблема	Решение
Ошибка аутентификации в YCR	Проверить YC_SA_KEY secret, обновить ключ
Не удается подключиться к кластеру	Проверить KUBE_CONFIG secret, обновить kubeconfig
Образ не обновляется	Установить imagePullPolicy: Always в deployment
Поды не запускаются	Проверить ресурсы (requests/limits), проверить статус PVC
Нет доступа к приложению	Проверить NodePort и Security Groups в Yandex Cloud
Terraform plan не работает	Проверить YC_TOKEN, CLOUD_ID, FOLDER_ID secrets
Скриншоты для отчета
1. GitHub Actions Pipeline
✅ Workflow deploy.yml успешно выполнен
✅ Workflow terraform-plan.yml успешно выполнен
✅ Workflow terraform-apply.yml успешно выполнен

2. Pull Request с Plan
✅ PR с комментарием Terraform Plan
✅ Показаны изменения инфраструктуры

3. Container Registry
✅ Образы в Yandex Container Registry
✅ Теги latest, {sha}, {version}

4. Kubernetes
✅ Поды в статусе Running
✅ Доступ к приложению по NodePort
✅ Доступ к Grafana

5. GitHub Release
✅ Созданный релиз с описанием

Дополнительные команды
Работа с образами:

# Список образов в реестре
yc container image list --registry-name test-app

# Удалить старый образ
yc container image delete <image-id>

# Очистка старых образов (keep last 5)
yc container image list --registry-name test-app --format json | \
  jq -r '.[] | select(.tags[0] != "latest") | .id' | \
  head -n -5 | xargs -I {} yc container image delete {}
Работа с кластером:

# Получить события кластера
kubectl get events --sort-by='.lastTimestamp'

# Описать под
kubectl describe pod <pod-name>

# Масштабировать деплой
kubectl scale deployment test-app --replicas=3

# Откатить деплой
kubectl rollout undo deployment/test-app
🔗 Полезные ссылки
Yandex Container Registry

GitHub Actions Documentation

Kubernetes Deployment

Docker Buildx

Terraform Best Practices

✅ Итог
После выполнения задания будет:

✅ CI/CD пайплайн в GitHub Actions (3 workflow)
✅ Автоматическая сборка Docker образа
✅ Автоматическая публикация в Yandex Container Registry
✅ Автоматический деплой в Kubernetes
✅ Terraform Plan при создании PR
✅ Terraform Apply при merge в main
✅ Полная документация всех компонентов
