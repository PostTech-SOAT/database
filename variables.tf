variable "application" {
  description = "Nome da aplicação usada para interpolar nomes de recursos e variavel environment"
  type        = string
}

variable "aws_region" {
  description = "Região AWS que será deployado os recursos"
  type        = string
}

variable "db_user" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_port" {}
variable "db_family_group" {}
variable "db_storage_encrypted" {}
variable "db_apply_immediately" {}
variable "db_backup_retention_period" {}
variable "db_instance_count" {}
variable "db_instance_type" {}
variable "serverless_config" {}