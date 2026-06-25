# --- Информация о сервисном аккаунте ---
output "service_account_id" {
  description = "ID созданного сервисного аккаунта"
  value       = yandex_iam_service_account.terraform_sa.id
}

output "service_account_name" {
  description = "Имя созданного сервисного аккаунта"
  value       = yandex_iam_service_account.terraform_sa.name
}

output "service_account_email" {
  description = "Email созданного сервисного аккаунта"
  value       = yandex_iam_service_account.terraform_sa.email
}

# --- Ключи сервисного аккаунта ---
output "service_account_access_key" {
  description = "Access key для сервисного аккаунта"
  value       = yandex_iam_service_account_static_access_key.sa_key.access_key
  sensitive   = true
}

output "service_account_secret_key" {
  description = "Secret key для сервисного аккаунта"
  value       = yandex_iam_service_account_static_access_key.sa_key.secret_key
  sensitive   = true
}

# --- Информация о бакете ---
output "bucket_name" {
  description = "Имя созданного S3 бакета"
  value       = yandex_storage_bucket.tf_state.bucket
}

output "bucket_url" {
  description = "URL созданного S3 бакета"
  value       = "s3://${yandex_storage_bucket.tf_state.bucket}"
}

# --- Статус бакета ---
output "bucket_versioning" {
  description = "Статус версионирования бакета"
  value       = yandex_storage_bucket.tf_state.versioning[0].enabled
}

# --- Теги бакета ---
output "bucket_tags" {
  description = "Теги созданного бакета"
  value       = yandex_storage_bucket.tf_state.tags
}

# --- Команды для настройки backend ---
output "backend_commands" {
  description = "Команды для настройки backend"
  value       = <<-EOT
    # Для настройки бекенда в 02-cluster:
    # Скопируйте эти значения в backend.hcl
    
    bucket     = "${yandex_storage_bucket.tf_state.bucket}"
    access_key = "${yandex_iam_service_account_static_access_key.sa_key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.sa_key.secret_key}"
  EOT
}
