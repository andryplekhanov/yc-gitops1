resource "yandex_kubernetes_cluster" "zonal-k8s-cluster" {
  name        = "kube-infra"
  description = "description"

  network_id = var.yc_network_id

  master {
    version = "1.29"
    zonal {
      zone      = var.zone[1]
      subnet_id = var.yc_subnet_ids[1]
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "20:00"
        duration   = "3h"
      }
    }

#    master_logging {
#      enabled = true
#      log_group_id = "${yandex_logging_group.log_group_resoruce_name.id}"
#      kube_apiserver_enabled = true
#      cluster_autoscaler_enabled = true
#      events_enabled = true
#      audit_enabled = true
#    }
  }

  service_account_id      = yandex_iam_service_account.editor-k8s.id
  node_service_account_id = yandex_iam_service_account.editor-k8s.id

#  labels = {
#    my_key       = "my_value"
#    my_other_key = "my_other_value"
#  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

#  kms_provider {
#    key_id = "${yandex_kms_symmetric_key.kms_key_resource_name.id}"
#  }
  depends_on = [
    yandex_iam_service_account.editor-k8s,
    yandex_vpc_security_group.k8s-main-sg,
    yandex_resourcemanager_folder_iam_member.editor-k8s,

  ]
}