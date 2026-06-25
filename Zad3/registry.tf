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
