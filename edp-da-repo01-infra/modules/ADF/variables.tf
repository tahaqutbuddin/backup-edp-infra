variable "name" {
  description = "Name of the Azure Data Factory"
}

variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_locat" {
  description = "Referenced Resource Group Location"
}

variable "sql_server" {
  description = "SQL Server information"
}

variable "aci" {
  description = "Container Instance details"
}

variable "raw_id" {
  description = "ID for the Raw Azure Data Lake Storage"
}

variable "land_id" {
  description = "ID for the Landing Azure Data Lake Storage"
}

variable "rg" {
  description = "Details or configuration related to the Client"
}

variable "keyvault" {
  description = "Referenced Key Vault"
}

variable "az_ir" {
  description = "Integration Runtime configuration"
}

variable "logs_workspace" {
  description = "Log Analytics Workspace id"
}
