output "yc_network_id" {
  value = yandex_vpc_network.k8s-network.id
}

output "yandex_vpc_subnet_id" {
  value = yandex_vpc_subnet.k8s-subnet-b.id
}

output "yandex_vpc_address" {
  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}

output "yandex_cm_certificate_id" {
  value = yandex_cm_certificate.certificate.id
}

output "k8s_cluster_id" {
  value = yandex_kubernetes_cluster.zonal-k8s-cluster.id
}

output "security_group_id" {
  value = yandex_vpc_security_group.k8s-main-sg.id
}

output "container_registry_id" {
  value = yandex_container_registry.default.id
}

output "postgres_cluster_id" {
  value = yandex_mdb_postgresql_cluster.postgresql-test.id
}
