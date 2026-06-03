output "bucket_details" {
  description = "Detailed bucket information"
  value = {
    name       = yandex_storage_bucket.tf_state.bucket
    id         = yandex_storage_bucket.tf_state.id
    tags       = yandex_storage_bucket.tf_state.tags
    versioning = yandex_storage_bucket.tf_state.versioning
  }
  sensitive = false
}
