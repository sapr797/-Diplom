# Задание 6: Установка и настройка CI/CD

## Описание

Настройка CI/CD системы для автоматической сборки Docker образа и деплоя приложения при изменениях в репозитории.

### Цель:
- ✅ Автоматическая сборка Docker образа при коммите в репозиторий
- ✅ Автоматическая отправка в Container Registry
- ✅ Автоматический деплой в Kubernetes кластер
- ✅ Деплой при создании тега (v1.0.0)

---

##  Структура
Zad6/
├── .github/
│ └── workflows/
│ ├── build.yml # Сборка образа
│ ├── deploy.yml # Деплой в K8s
│ └── release.yml # Деплой по тегу
├── scripts/
│ ├── build.sh # Сборка
│ ├── push.sh # Публикация
│ ├── deploy.sh # Деплой
│ └── release.sh # Релиз
├── k8s/
│ ├── deployment.yaml # Деплой приложения
│ ├── service.yaml # Сервис
│ ├── ingress.yaml # Ingress
│ └── configmap.yaml # Конфигурация
├── docker/
│ ├── Dockerfile # Dockerfile
│ └── .dockerignore # Исключения
├── monitoring/
│ └── values.yaml # Конфигурация мониторинга
└── README.md # Документация


