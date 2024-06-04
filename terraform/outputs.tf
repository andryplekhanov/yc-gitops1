output "cluster_id" {
  value = yandex_kubernetes_cluster.zonal-k8s-cluster.id
}

output "security_group_id" {
  value = yandex_vpc_security_group.k8s-main-sg.id
}

output "container_registry_id" {
  value = yandex_container_registry.default.id
}
