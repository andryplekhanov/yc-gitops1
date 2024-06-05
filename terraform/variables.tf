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
  description = "$USER"
}

variable "yc_network_id" {
  description = "Default network ID in yandex cloud"
  type        = string
  default     = "enpaf3uu4ql2vqmn3ffh"
}

variable "yc_subnet_ids" {
  description = "Default subnet IDs in yandex cloud"
  type        = list(string)
  default     = ["e9bqn0jaap861sq1ucc4", "e2ljdd9p8jgkd4mo0imi", "fl8ampu7udov950kmji9"]
}

variable "zone" {
  description = "Use specific availability zone"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "db_password" {
  type        = string
  default     = "123456qwerty"
  description = "Default password for PostgreSQL"
  sensitive   = true
}

variable "db_username" {
  type        = string
  default     = "db_username"
  description = "Default username for PostgreSQL"
  sensitive   = true
}

variable "db_name" {
  type        = string
  default     = "db_name"
  description = "Default name for PostgreSQL"
  sensitive   = true
}