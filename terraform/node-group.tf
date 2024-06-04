resource "yandex_kubernetes_node_group" "node-group1" {
  cluster_id  = "${yandex_kubernetes_cluster.zonal-k8s-cluster.id}"
  name        = "group-1"
  description = "description"
  version     = "1.29"

#  labels = {
#    "key" = "value"
#  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [var.yc_subnet_ids[1]]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
    }

    metadata = {
      ssh-keys = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 2
      max = 4
      min = 1
    }
  }

  allocation_policy {
    location {
      zone = var.zone[1]
    }
  }

#  maintenance_policy {
#    auto_upgrade = true
#    auto_repair  = true
#
#    maintenance_window {
#      day        = "monday"
#      start_time = "15:00"
#      duration   = "3h"
#    }
#
#    maintenance_window {
#      day        = "friday"
#      start_time = "10:00"
#      duration   = "4h30m"
#    }
#  }
  depends_on = [
    yandex_kubernetes_cluster.zonal-k8s-cluster,
  ]
}