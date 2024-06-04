resource "yandex_container_registry" "default" {
  name      = "test-registry"
  folder_id = var.yc_folder

}