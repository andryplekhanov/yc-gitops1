# Создание кластера с одним хостом. Документация и др. примеры:
# https://yandex.cloud/ru/docs/managed-postgresql/operations/cluster-create

resource "yandex_mdb_postgresql_cluster" "postgresql-test" {
  name        = "postgresql-test"
  environment = "PRODUCTION"
  network_id  = var.yc_network_id
  security_group_ids  = [ yandex_vpc_security_group.pgsql-sg.id ]

  config {
    version = 15
    resources {
      resource_preset_id = "c3-c2-m4"  # https://yandex.cloud/ru/docs/managed-postgresql/concepts/instance-types
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
#     postgresql_config = {
#       max_connections                   = 395
#       enable_parallel_hash              = true
#       autovacuum_vacuum_scale_factor    = 0.34
#       default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
#       shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
#     }
  }

#   maintenance_window {
#     type = "WEEKLY"
#     day  = "SAT"
#     hour = 12
#   }

  host {
    zone      = var.zone[1]
    subnet_id = var.yc_subnet_ids[1]
  }
  depends_on = [
    yandex_vpc_security_group.pgsql-sg
  ]
}

resource "yandex_mdb_postgresql_database" "db-postgres" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql-test.id
  name       = var.db_name
  owner      = var.db_username
  depends_on = [
    yandex_mdb_postgresql_cluster.postgresql-test,
    yandex_mdb_postgresql_user.db-user
  ]
}

resource "yandex_mdb_postgresql_user" "db-user" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql-test.id
  name       = var.db_username
  password   = var.db_password
  depends_on = [
    yandex_mdb_postgresql_cluster.postgresql-test,
  ]
}

