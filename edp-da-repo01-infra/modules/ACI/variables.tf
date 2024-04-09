variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_locat" {
  description = "Referenced Resource Group Location"
}

variable "name" {
  description = "Name of the ACI"
}

variable "img" {
  description = "Image Name"
}

variable "cont" {
  description = "Container Name"
}

variable "server" {
  description = "Server Name for Image Registry Credential"
}

variable "username" {
  description = "Username for Image Registry Credential"
}

variable "password" {
  description = "Password for Image Registry Credential"
}

variable "aci_subnet" {
  description = "ACI Subnet Name"
}

variable "sqlsrvr" {
  description = "Referenced SQL Server"
}

variable "keyvault" {
  description = "Referenced Key Vault"
}

variable "acr_id" {
  description = "Id of the ACR"
}

variable "logs_workspace" {
  description = "Log Analytics Workspace id"
}

  