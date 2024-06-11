variable "yc_cloud" {
  description = "Default cloud ID in yandex cloud"
  type        = string
  default     = ""
}

variable "yc_folder" {
  description = "Default folder ID in yandex cloud"
  type        = string
  default     = ""
}

variable "yc_token" {
  type        = string
  default     = ""
  description = "Default cloud token in yandex cloud"
  sensitive   = true
}

variable "user" {
  type        = string
  description = ""
}

variable "zone" {
  description = "Use specific availability zone"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Your site's name, for example 'andreiplekhanov.ru'"
}

variable "db_password" {
  type        = string
  default     = ""
  description = "Default password for PostgreSQL"
  sensitive   = true
}

variable "db_username" {
  type        = string
  default     = ""
  description = "Default username for PostgreSQL"
  sensitive   = true
}

variable "db_name" {
  type        = string
  default     = ""
  description = "Default name for PostgreSQL"
  sensitive   = true
}
