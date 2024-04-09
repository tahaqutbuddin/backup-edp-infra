variable "prefix" {
  default = "att-edp-da"
}

variable "env" {
  default = "dev"
}

variable "acr" {
  default = "attedpdacr01DBTdev001"
}

variable "infra_base_kv" {
  default = "kv01"
}

//-------------------------- SQL Server --------------------------
variable "sql_server_name" {
  default = "sql01-dw"
}

variable "server_username" {
  default = "sqladmin"
}

variable "server_pass" {
  default = "P@ssword1234"
}

//-------------------------- Service Now SQL --------------------------
variable "sn_db" {
  default = "sqldb01-dw-sn"
}

//-------------------------- DCS SQL --------------------------
variable "dcs_db" {
  default = "sqldb01-dw-dcs"
}

//-------------------------- Storage Accounts --------------------------
variable "raw_adls_name" {
  default = "attedpdadls01rawdev"
}

variable "lnd_adls_name" {
  default = "attedpdadls01lnddev"
}

//-------------------------- Managed Identity  --------------------------
variable "m_id_name" {
  default = "id01-cr01"
}

//-------------------------- Log analytics --------------------------
variable "log_analytics_name" {
  default = "att-edp-da-la01-dev"
}
variable "logs_storage_account_name" {
  default = "attedpdadlslogs01dev"
}
