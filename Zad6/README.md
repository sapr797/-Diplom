# Задание 6: Установка и настройка CI/CD

## Описание

Настройка CI/CD системы для автоматической сборки Docker образа и деплоя приложения при изменениях в репозитории.

### Цель:
- ✅ Автоматическая сборка Docker образа при коммите в репозиторий
- ✅ Автоматическая отправка в Container Registry
- ✅ Автоматический деплой в Kubernetes кластер
- ✅ Деплой при создании тега (v1.0.0)

---

## 📁 Структура проекта
Zad6/
├── .github/
│ └── workflows/
│ ├── build.yml # Сборка образа при push/PR
│ ├── deploy.yml # Деплой в K8s при merge в main
│ └── release.yml # Деплой по тегу v*
├── scripts/
│ ├── build.sh # Локальная сборка образа
│ ├── push.sh # Публикация в YCR
│ ├── deploy.sh # Деплой в K8s
│ └── release.sh # Полный релизный процесс
├── k8s/
│ ├── deployment.yaml # Деплой приложения
│ ├── service.yaml # Сервис (NodePort)
│ ├── ingress.yaml # Ingress для доступа
│ └── configmap.yaml # Конфигурация приложения
├── docker/
│ ├── Dockerfile # Dockerfile с nginx
│ └── .dockerignore # Исключения для сборки
├── monitoring/
│ └── values.yaml # Конфигурация мониторинга
└── README.md # Документация

---

## Описание файлов

### 1. GitHub Actions Workflows

#### `build.yml`
- **Триггеры**: Push в main/develop, Pull Request в main
- **Что делает**:
  - Собирает Docker образ
  - Для PR: проверяет сборку (без публикации)
  - Для main: собирает и публикует с тегами `latest` и `{sha}`
- **Использует**: Docker Buildx, кэширование через GitHub Actions cache

#### `deploy.yml`
- **Триггеры**: Push в main (при изменении k8s манифестов)
- **Что делает**:
  - Применяет все манифесты из `k8s/`
  - Ожидает готовности деплоя
  - Проверяет статус подов и сервисов
- **Использует**: kubectl, kubeconfig из Secrets

#### `release.yml`
- **Триггеры**: Создание тега `v*` (например, v1.0.0)
- **Что делает**:
  - Собирает образ с тегом версии (v1.0.0)
  - Публикует с тегами `{version}` и `latest`
  - Обновляет deployment с новым тегом
  - Создает GitHub Release с описанием

---

### 2. Скрипты для локального запуска

#### `build.sh`
- Собирает Docker образ локально
- Принимает параметр: тег (по умолчанию `latest`)
- Использует контекст из `docker/`

#### `push.sh`
- Публикует образ в Yandex Container Registry
- Требует аутентификации через `yc container registry configure-docker`

#### `deploy.sh`
- Применяет все k8s манифесты
- Ожидает готовности деплоя
- Выводит URL для доступа

#### `release.sh`
- Полный релизный процесс:
  1. Сборка образа с тегом версии
  2. Публикация в YCR
  3. Обновление deployment
  4. Деплой в K8s

---

### 3. Kubernetes манифесты

#### `deployment.yaml`
- **Ресурсы**: 2 реплики
- **Образ**: `cr.yandex/REGISTRY_ID/test-app:latest`
- **Probes**: Readiness + Liveness (health-проверка)
- **Ресурсы**: requests (64Mi/50m) и limits (128Mi/100m)

#### `service.yaml`
- **Тип**: NodePort
- **Порт**: 80 → 30080
- **Селектор**: app: test-app

#### `ingress.yaml`
- **Хост**: app.local (можно заменить на реальный домен)
- **Аннотации**: nginx.ingress.kubernetes.io/rewrite-target

#### `configmap.yaml`
- **Данные**: ENVIRONMENT=production, VERSION, LOG_LEVEL

---

### 4. Docker

#### `Dockerfile`
- **Базовый образ**: `nginx:alpine` (легкий, ~5MB)
- **Содержимое**: копирует index.html и nginx.conf
- **Health-проверки**: эндпоинты `/health` и `/version`

#### `.dockerignore`
- Исключает: .git, .github, README.md, *.md, .vscode, .idea

#### `index.html`
- Современный дизайн с градиентом
- Отображает версию и время деплоя
- Адаптивный дизайн

#### `nginx.conf`
- Кастомная конфигурация nginx
- Эндпоинты: `/` (основной), `/health` (health-check), `/version`

---

### 5. Мониторинг

#### `values.yaml`
- **Grafana**: NodePort 30090, пароль admin123
- **Prometheus**: NodePort 30091
- **Alertmanager**: NodePort 30093
- Используется для установки через Helm

---

## 🔐 Настройка Secrets в GitHub

Для работы CI/CD необходимо добавить следующие secrets в репозиторий:

| Secret | Описание | Как получить |
|--------|----------|--------------|
| `YC_SA_KEY` | JSON ключ сервисного аккаунта | Скачать из консоли Yandex Cloud |
| `KUBE_CONFIG` | kubeconfig (base64) | `cat ~/.kube/config \| base64 -w 0` |
| `REGISTRY_ID` | ID Container Registry | `yc container registry list` |
| `CLOUD_ID` | ID облака | `yc config list` |
| `FOLDER_ID` | ID каталога | `yc config list` |
| `YC_TOKEN` | IAM токен | `yc iam create-token` |

---

## 🚀 Процесс работы

### Обычный коммит в main
1. Разработчик делает push в ветку `main`
2. GitHub Actions:
   - Собирает Docker образ
   - Публикует в YCR с тегами `latest` и `{sha}`
   - Обновляет deployment (если изменены манифесты)

### Pull Request
1. Создается PR в `main`
2. GitHub Actions:
   - Собирает Docker образ (без публикации)
   - Проверяет корректность сборки
   - Выводит результат проверки в PR

### Релиз (создание тега)
1. Создается тег `v1.0.0`
2. GitHub Actions:
   - Собирает образ с тегом `v1.0.0`
   - Публикует в YCR
   - Создает GitHub Release
   - Обновляет deployment

---

## 📊 Доступ к сервисам

| Сервис | URL | Данные для входа |
|--------|-----|------------------|
| **Тестовое приложение** | `http://<NODE_IP>:30080` | — |
| **Grafana** | `http://<NODE_IP>:30090` | admin / admin123 |
| **Prometheus** | `http://<NODE_IP>:30091` | — |
| **Alertmanager** | `http://<NODE_IP>:30093` | — |

### Как получить Node IP:
```
kubectl get nodes -o wide | awk '{print $1, $7}'
🧪 Проверка работы
Локальная проверка
# Сборка образа
./scripts/build.sh v1.0.0

# Публикация
./scripts/push.sh v1.0.0

# Деплой
./scripts/deploy.sh
Проверка в кластере

# Статус подов
kubectl get pods -n default

# Статус сервисов
kubectl get svc -n default

# Логи приложения
kubectl logs -l app=test-app

# Проверка health-эндпоинта
curl http://<NODE_IP>:30080/health
📸 Скриншоты для отчета
1. GitHub Actions Pipeline
✅ Workflow build.yml успешно выполнен

✅ Workflow deploy.yml успешно выполнен

✅ Workflow release.yml успешно выполнен

2. Pull Request
✅ PR с комментарием о результатах сборки

3. Container Registry
✅ Образы в Yandex Container Registry

4. Kubernetes
✅ Поды в статусе Running

✅ Доступ к приложению по NodePort

5. GitHub Release
✅ Созданный релиз с описанием

🔧 Возможные проблемы и их решение
Проблема	Решение
Ошибка аутентификации в YCR	Проверить YC_SA_KEY secret
Не удается подключиться к кластеру	Проверить KUBE_CONFIG secret
Образ не обновляется	Проверить imagePullPolicy: Always
Поды не запускаются	Проверить ресурсы (requests/limits)
Нет доступа к приложению	Проверить NodePort и Security Groups
Команды для быстрого старта

# Клонирование
git clone <repository>

# Настройка Secrets в GitHub
# Перейти в Settings → Secrets and variables → Actions

# Локальный деплой
cd Zad6
chmod +x scripts/*.sh
./scripts/build.sh
./scripts/push.sh
./scripts/deploy.sh

# Проверка
kubectl get pods
kubectl get svc
 Полезные ссылки
Yandex Container Registry

GitHub Actions Documentation

Kubernetes Deployment

Docker Buildx

✅ Итог
После выполнения задания будет:
✅ CI/CD пайплайн в GitHub Actions
✅ Автоматическая сборка Docker образа
✅ Автоматический деплой в Kubernetes
✅ Релизный процесс по тегам
✅ Мониторинг состояния приложения
✅ Документация всех компонентов
