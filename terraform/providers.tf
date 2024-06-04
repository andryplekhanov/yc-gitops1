terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.118.0"
    }
  }
}

provider "yandex" {
  zone      = var.zone[1]
  cloud_id  = var.yc_cloud
  folder_id = var.yc_folder
  token     = var.yc_token
}