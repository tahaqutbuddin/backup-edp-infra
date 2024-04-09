//----------------------- Import Existing Resources -----------------------
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "dev-rg" {
  name = "att-edp-da-rg01-dev"
}

data "azurerm_container_registry" "edp_acr" {
  name = "attedpdacr01DBTdev001"
  resource_group_name = "att-edp-da-rg01-dev"
}

data "azurerm_key_vault" "infra_base_kv" {
  name                = "att-edp-da-kv01-dev"
  resource_group_name = "att-edp-da-rg01-dev"
}

data "azurerm_mssql_server" "dev-sql-server" {
  name = "att-edp-da-sql01-dw-dev"
  resource_group_name = data.azurerm_resource_group.dev-rg.name
}

data "azurerm_storage_account" "rawADLS" {
  name = "attedpdadls01rawdev"
  resource_group_name = data.azurerm_resource_group.dev-rg.name
}

data "azurerm_storage_account" "lndADLS" {
  name = "attedpdadls01lnddev"
  resource_group_name = data.azurerm_resource_group.dev-rg.name
}

data "azurerm_user_assigned_identity" "m_id" {
  name = "att-edp-da-id01-cr01-dev"
  resource_group_name = data.azurerm_resource_group.dev-rg.name
}

data "azurerm_log_analytics_workspace" "logs_workspace"{
  name = "att-edp-da-la01-dev"
  resource_group_name = data.azurerm_resource_group.dev-rg.name
}

//---------------------------- ACI -------------------------------------------
module "aci_instance" {
  source = "../modules/ACI"
  name = "${var.prefix}-${var.aci_name}-${var.env}001"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_locat = data.azurerm_resource_group.dev-rg.location
  cont = "${var.prefix}-${var.aci_cont}-${var.env}001"
  img = var.aci_img
  aci_subnet = module.internal_vnet.container_subnet_details
  server = data.azurerm_container_registry.edp_acr.login_server
  username = data.azurerm_container_registry.edp_acr.admin_username
  password = data.azurerm_container_registry.edp_acr.admin_password
  sqlsrvr = data.azurerm_mssql_server.dev-sql-server
  keyvault = data.azurerm_key_vault.infra_base_kv
  acr_id = data.azurerm_container_registry.edp_acr.id
  logs_workspace = data.azurerm_log_analytics_workspace.logs_workspace
}

//---------------------------- Azure Data Factory -------------------------------------------
module "adf" {
  source = "../modules/ADF"

  name = "${var.prefix}-${var.adf_name}-${var.env}001"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_locat = data.azurerm_resource_group.dev-rg.location
  sql_server = data.azurerm_mssql_server.dev-sql-server
  az_ir = var.az_ir_name_full
  aci = module.aci_instance.aci
  raw_id = data.azurerm_storage_account.rawADLS.id
  land_id = data.azurerm_storage_account.lndADLS.id
  rg = data.azurerm_resource_group.dev-rg
  keyvault = data.azurerm_key_vault.infra_base_kv
  logs_workspace = data.azurerm_log_analytics_workspace.logs_workspace
}

//---------------------------- Virtual Networks -------------------------------------------
module "internal_vnet" {
  source = "../modules/Internal_Vnet"

  name = "${var.prefix}-${var.internal_vnet_name}-${var.env}"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_locat = data.azurerm_resource_group.dev-rg.location
  internal_snet = "${var.prefix}-${var.snet_name}-${var.env}"
  vnet_address = var.vnet_address
  snet_address = var.snet_address
  container_snet_address = var.aci_snet_address
}

//---------------------------- Azure Virtual Desktop -------------------------------------------
module "avd" {
  source = "../modules/AVD"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_location = data.azurerm_resource_group.dev-rg.location
  host_pool_name = "${var.prefix}-${var.host_pool}-${var.env}"
  expiration_days = 2
  admin_username = "avd-admin"
  admin_password = "Taha-1234"
  workspace_name = "${var.prefix}-${var.workspace}-${var.env}"
  dag = "${var.prefix}-${var.vm_dag}-${var.env}"
  avd_nic = "${var.prefix}-${var.vm_nic}-${var.env}"
  vm_name = "${var.prefix}-vm01-${var.env}"
  vm_size = "Standard_DS1_v2"
  domain_name = "saqibperwaizgmail.onmicrosoft.com"
  subnet_id = module.internal_vnet.internal_subnet_details.id
  computer_name = "Desktop"   #can't be more than 15 characters
}

//---------------------------- rawADLS Private Endpoint -------------------------------------------
module "rawADLS_private_endpoint" {
  source = "../modules/PEP"
  
  service = "st_rawalds"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_location = data.azurerm_resource_group.dev-rg.location
  resource = data.azurerm_storage_account.rawADLS
  dns_zone = var.rawalds_st_dns
  vlink = "${var.prefix}-${var.rawalds_st_pl}-${var.env}"
  subnet_id = module.internal_vnet.internal_subnet_details.id
  endpoint = "${var.prefix}-${var.rawalds_st_pep}-${var.env}"
  subresource = "blob"
  internal_vnet = module.internal_vnet.internal_vnet_details
}

//---------------------------- lndADLS Private Endpoint -------------------------------------------
module "lndADLS" {
  source = "../modules/PEP"
  
  service = "st_lndalds"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_location = data.azurerm_resource_group.dev-rg.location
  resource = data.azurerm_storage_account.lndADLS
  dns_zone = var.lndalds_st_dns
  vlink = "${var.prefix}-${var.lndalds_st_pl}-${var.env}"
  subnet_id = module.internal_vnet.internal_subnet_details.id
  endpoint = "${var.prefix}-${var.lndalds_st_pep}-${var.env}"
  subresource = "blob"
  internal_vnet = module.internal_vnet.internal_vnet_details
}

//---------------------------- SQL Server Private Endpoint using PEP module -------------------------------------------

module "sql_pvt_endpoint" {
  source = "../modules/PEP"
  
  service = "sql_server"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_location = data.azurerm_resource_group.dev-rg.location
  resource = data.azurerm_mssql_server.dev-sql-server
  dns_zone = var.invnetsql_dns
  vlink = "${var.prefix}-${var.invnetsql_pl}-${var.env}"
  subnet_id = module.internal_vnet.internal_subnet_details.id
  endpoint ="${var.prefix}-${ var.invnetsql_pep}-${var.env}"
  internal_vnet = module.internal_vnet.internal_vnet_details
  subresource = "SqlServer"
}

//---------------------------- ADF Private Endpoint using PEP module -------------------------------------------

module "adf_private_endpoint" {
  source = "../modules/PEP"

  service = "adf"
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_location = data.azurerm_resource_group.dev-rg.location
  resource = module.adf.adf
  dns_zone =  var.adf_dns
  vlink = "${var.prefix}-${var.adf_pl}-${var.env}"
  subnet_id = module.internal_vnet.internal_subnet_details.id
  endpoint ="${var.prefix}-${ var.adf_pep}-${var.env}"
  internal_vnet = module.internal_vnet.internal_vnet_details
  subresource = "dataFactory"
}

//---------------------------- Log analytics -------------------------------------------

module "log_analytics" {
  source = "../modules/Log_Analytics"
  name = var.log_analytics_name
  rg_name = data.azurerm_resource_group.dev-rg.name
  rg_locat = data.azurerm_resource_group.dev-rg.location
  storage_account_name = var.logs_storage_account_name 
}



