resource "yandex_vpc_network" "k8s-network" {
  name = "default"
}

resource "yandex_vpc_subnet" "k8s-subnet-a" {
  name = "default-ru-central1-a"
  v4_cidr_blocks = ["10.128.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-network.id
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}

resource "yandex_vpc_subnet" "k8s-subnet-b" {
  name = "default-ru-central1-b"
  v4_cidr_blocks = ["10.129.0.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s-network.id
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}

resource "yandex_vpc_subnet" "k8s-subnet-c" {
  name = "default-ru-central1-c"
  v4_cidr_blocks = ["10.130.0.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.k8s-network.id
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}

resource "yandex_vpc_subnet" "k8s-subnet-d" {
  name = "default-ru-central1-d"
  v4_cidr_blocks = ["10.131.0.0/24"]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.k8s-network.id
  depends_on = [
    yandex_vpc_network.k8s-network,
  ]
}
