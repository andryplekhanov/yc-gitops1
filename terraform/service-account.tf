# Создание сервисного аккаунта editor-k8s
resource "yandex_iam_service_account" "editor-k8s" {
  name = "kube-infra"
}

# назначаем сервисному аккаунту "editor-k8s" роль editor
# от его имени будут создаваться ресурсы, необходимые кластеру Kubernetes
resource "yandex_resourcemanager_folder_iam_member" "editor-k8s" {
  folder_id = var.yc_folder
  role = "editor"
  member = "serviceAccount:${yandex_iam_service_account.editor-k8s.id}"
  depends_on = [
    yandex_iam_service_account.editor-k8s,
  ]
  sleep_after = 30
}


# Создание сервисного аккаунта ingress-controller
resource "yandex_iam_service_account" "ingress-controller" {
  name = "ingress-controller"
}

# назначаем сервисному аккаунту ingress-controller роль alb.editor
resource "yandex_resourcemanager_folder_iam_binding" "ingress-alb-editor" {
  folder_id   = var.yc_folder
  role = "alb.editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.ingress-controller.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ingress-controller,
  ]
}

# назначаем сервисному аккаунту ingress-controller роль vpc.publicAdmin
resource "yandex_resourcemanager_folder_iam_binding" "ingress-vpc-public-admin" {
  folder_id   = var.yc_folder
  role = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.ingress-controller.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ingress-controller,
  ]
}

# назначаем сервисному аккаунту ingress-controller роль certificate-manager.certificates.downloader
resource "yandex_resourcemanager_folder_iam_binding" "ingress-cert-downloader" {
  folder_id   = var.yc_folder
  role = "certificate-manager.certificates.downloader"
  members = [
    "serviceAccount:${yandex_iam_service_account.ingress-controller.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ingress-controller,
  ]
}

# назначаем сервисному аккаунту ingress-controller роль compute.viewer
resource "yandex_resourcemanager_folder_iam_binding" "ingress-compute-viewer" {
  folder_id   = var.yc_folder
  role = "compute.viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.ingress-controller.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ingress-controller,
  ]
}

# Создание сервисного аккаунта registry-puller
resource "yandex_iam_service_account" "registry-puller" {
  name        = "registry-puller"
  description = "service account to manage docker images on nodes"
}

# назначаем сервисному аккаунту роль container-registry.images.puller
# от его имени будут стягиваться образы из container-registry
resource "yandex_resourcemanager_folder_iam_binding" "folder-puller" {
  folder_id   = var.yc_folder
  role = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.registry-puller.id}",
  ]
}

# Создание сервисного аккаунта registry-pusher
resource "yandex_iam_service_account" "registry-pusher" {
  name        = "registry-pusher"
  description = "service account to manage docker images on nodes"
}

# назначаем сервисному аккаунту роль container-registry.images.pusher
# от его имени будут стягиваться образы из container-registry
resource "yandex_resourcemanager_folder_iam_binding" "folder-pusher" {
  folder_id   = var.yc_folder
  role = "container-registry.images.pusher"
  members = [
    "serviceAccount:${yandex_iam_service_account.registry-pusher.id}",
  ]
}