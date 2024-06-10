resource "yandex_vpc_address" "addr" {
  name = "alb-address"
  folder_id = var.yc_folder
  external_ipv4_address {
    zone_id = var.zone[1]
  }
  depends_on = [
    yandex_vpc_network.k8s-network,
    yandex_vpc_subnet.k8s-subnet-b
  ]
}

resource "yandex_dns_zone" "zone1" {
  name        = "my-dns-zone"
  description = "description"

  zone             = "${var.domain_name}."
  public           = true
#  private_networks = [yandex_vpc_network.k8s-network.id]

  deletion_protection = false
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "*.${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
  depends_on = [
    yandex_vpc_network.k8s-network,
    yandex_vpc_address.addr,
    yandex_dns_zone.zone1
  ]
}

resource "yandex_cm_certificate" "certificate" {
  name    = "certificate"
  domains = ["*.${var.domain_name}"]

  managed {
    challenge_type = "DNS_CNAME"
  }
  depends_on = [
    yandex_dns_recordset.rs1
  ]
}

resource "yandex_dns_recordset" "validation-record" {
  zone_id = yandex_dns_zone.zone1.id
  name    = yandex_cm_certificate.certificate.challenges[0].dns_name
  type    = yandex_cm_certificate.certificate.challenges[0].dns_type
  data    = [yandex_cm_certificate.certificate.challenges[0].dns_value]
  ttl     = 600
  depends_on = [
    yandex_cm_certificate.certificate
  ]
}