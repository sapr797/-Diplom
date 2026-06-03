
Zad5: CI/CD Pipeline
Описание
Автоматическая сборка и деплой приложения при изменениях в репозитории.

GitHub Actions Workflow
Триггеры
Push в ветку main

Pull Request в main

Jobs
build - сборка Docker образа

push - отправка в Container Registry

deploy - деплой в Kubernetes

Настройка Secrets в GitHub
Для работы CI/CD необходимо добавить следующие secrets:

SecretОписание
YC_SA_KEYJSON ключ сервисного аккаунта
KUBE_CONFIGkubeconfig для доступа к кластеру
Workflow файл
.github/workflows/deploy.yml

Процесс
Код коммитится в main

GitHub Actions собирает Docker образ

Образ пушится в Yandex Container Registry

Выполняется деплой в Kubernetes

Ручной деплой
bash
kubectl apply -f Zad3/deployment.yaml
