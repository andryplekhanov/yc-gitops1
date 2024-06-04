resource "yandex_vpc_security_group" "k8s-main-sg" {
  name        = "yc-security-group"
  description = "Правила группы обеспечивают базовую работоспособность кластера. Примените ее к кластеру и группам узлов."
  network_id  = var.yc_network_id

  ingress {
    description = "Allow HTTPS"
    protocol    = "TCP"
    port        = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    protocol    = "TCP"
    port        = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    v4_cidr_blocks    = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol       = "ANY"
    description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов."
    v4_cidr_blocks = ["10.96.0.0/16", "10.112.0.0/16"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "ICMP"
    description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}