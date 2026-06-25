# Задание 5: CI/CD Pipeline

## Описание

Настройка автоматического CI/CD пайплайна для сборки и деплоя приложения при изменениях в репозитории.

### Цель:
- ✅ Автоматическая сборка Docker образа при коммите в main
- ✅ Автоматическая публикация в Yandex Container Registry
- ✅ Автоматический деплой в Kubernetes кластер
- ✅ Проверка через Pull Request

---

## Структура
Zad5/
├── .github/
│ └── workflows/
│ ├── deploy.yml # Основной пайплайн
│ ├── terraform-plan.yml # Plan при PR
│ └── terraform-apply.yml # Apply при merge
├── scripts/
│ ├── build.sh # Сборка образа
│ ├── push.sh # Публикация в YCR
│ └── deploy.sh # Деплой в K8s
└── README.md # Документация
🔐 Настройка Secrets в GitHub
Необходимые Secrets:
Secret	Описание	Где взять
YC_TOKEN	IAM токен	yc iam create-token
YC_SA_KEY	JSON ключ сервисного аккаунта	Скачать из консоли
CLOUD_ID	ID облака	yc config list
FOLDER_ID	ID каталога	yc config list
REGISTRY_ID	ID Container Registry	yc container registry list
KUBE_CONFIG	kubeconfig (base64)	cat ~/.kube/config | base64 -w 0
Добавление Secrets в GitHub:
Перейдите в репозиторий → Settings → Secrets and variables → Actions
Нажмите New repository secret

Добавьте каждый секрет:

# Получить kubeconfig в base64
cat ~/.kube/config | base64 -w 0

# Получить IAM токен
yc iam create-token

# Получить ID реестра
yc container registry list
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

