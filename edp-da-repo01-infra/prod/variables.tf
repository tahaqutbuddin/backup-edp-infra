variable "prefix" {
  default = "att-edp-da"
}

variable "env" {
  default = "prod"
}
//-------------------------- Azure Data Factory --------------------------
variable "adf_name" {
  default = "adf01"
}

//-------------------------- Azure Integration Runtime --------------------------
variable "az_ir_name" {
  default = "ir1"
}

variable "az_ir_name_full" {
  default = "AutoResolveIntegrationRuntime"
}


//-------------------------- Virtual Networks --------------------------
variable "internal_vnet_name" {
  default = "vnet01"
}

variable "snet_name" {
  default = "snet01-int"
}
//-------------------------- ACI  --------------------------
variable "aci_name" {
  default ="ci01-sn"
}
variable "aci_cont" {
  default = "ci01"
}
variable "aci_img" {
  default = "attedpdacr01dbtprod001.azurecr.io/attedpdarepoacrsn:latest"
}
//-------------------------- Internal VNET SQL Private Endpoint --------------------------
variable "invnetsql_dns" {
  default = "privatelink.database.windows.net"
}

variable "invnetsql_pl" {
  default = "sqlpep-invnetpl01"
}

variable "invnetsql_pep" {
  default = "pep01-internalvnet-sqldw"
}
//-------------------------- ADF Private Endpoint --------------------------
variable "adf_dns" {
  default = "privatelink.datafactory.azure.net"
}
variable "adf_pl" {
  default = "adfpep-invnetpl01"
}
variable "adf_pep" {
  default = "pep01-internalvnet-adf"
}

variable "vnet_address" {
  default = ["10.105.0.0/23"] 
}
variable "snet_address" {
  default = ["10.105.0.0/28"]
}
variable "aci_snet_address" {
  default = ["10.105.0.16/28"] 
}


//-------------------------- Azure Virtual Desktop --------------------------
variable "host_pool" {
  default = "vdpool01"
}

variable "workspace" {
  default = "vdws01"
}

variable "vm_dag" {
  default = "dag01"
}

variable "vm_nic" {
  default = "nic01"
}

//-------------------------- rawADLS Storage Account Private Endpoint --------------------------
variable "rawalds_st_dns" {
  default = "privatelink.blob.core.windows.net"
}
variable "rawalds_st_pl" {
  default = "rawadls-invnetpl01"
}
variable "rawalds_st_pep" {
  default = "pep01-internalvnet-rawadls"
}

//-------------------------- lndADLS Storage Account Private Endpoint --------------------------
variable "lndalds_st_dns" {
  default = "privatelink.blob.core.windows.net"
}
variable "lndalds_st_pl" {
  default = "lndadls-invnetpl01"
}
variable "lndalds_st_pep" {
  default = "pep01-internalvnet-lndadls"
}

//-------------------------- Log analytics --------------------------
variable "log_analytics_name" {
  default = "att-edp-da-la01-prod"
}
variable "logs_storage_account_name" {
  default = "attedpdadlslogs01prod"
}
