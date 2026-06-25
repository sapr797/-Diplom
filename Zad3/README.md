
# 🚀 Задание 3: Тестовое приложение

## 📋 Описание

Создание тестового приложения на базе nginx для демонстрации работы Kubernetes кластера.

### Что сделано:
- ✅ Создан отдельный git репозиторий с тестовым приложением
- ✅ Подготовлен Dockerfile для сборки образа
- ✅ Настроен nginx для отдачи статических данных
- ✅ Создан манифест для деплоя в Kubernetes
- ✅ Подготовлена конфигурация для Yandex Container Registry

---

## 📁 Структура репозитория
test-app/
├── Dockerfile # Сборка образа
├── index.html # Статическая страница
├── deployment.yaml # Kubernetes манифест
├── .dockerignore # Исключения для сборки
└── README.md # Документация

text

---

## 📄 Файлы

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
