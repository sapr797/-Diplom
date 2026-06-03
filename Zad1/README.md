# Zad1: Service Account and S3 Bucket

## Описание
Создание сервисного аккаунта и S3 бакета для хранения state файлов Terraform.

## Файлы
- `main.tf` - основная конфигурация Terraform
- `variables.tf` - объявление переменных
- `outputs.tf` - выходные данные
- `terraform.tfvars` - значения переменных

## Переменные
| Имя | Описание | Значение |
|-----|----------|----------|
| cloud_id | ID облака | b1g36426920rk8dvvn2r |
| folder_id | ID каталога | b1gsq7mn8r0m1g4qf15j |
| service_account_name | Имя сервисного аккаунта | terraform-sa-dz3 |
| bucket_name | Имя S3 бакета | tf-state-dev-xxxxx |

## Запуск
```bash
terraform init
terraform plan
terraform apply -auto-approve
Вывод
bucket_name - имя созданного S3 бакета

access_key - ключ доступа

secret_key - секретный ключ

service_account_id - ID сервисного аккаунта
