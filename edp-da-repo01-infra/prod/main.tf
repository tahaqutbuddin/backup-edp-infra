//----------------------- Import Existing Resources -----------------------
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "prod-rg" {
  name = "att-edp-da-rg01-prod"
}

data "azurerm_container_registry" "edp_acr" {
  name = "attedpdacr01DBTprod001"
  resource_group_name = "att-edp-da-rg01-prod"
}

data "azurerm_key_vault" "infra_base_kv" {
  name                = "att-edp-da-kv01-prod"
  resource_group_name = "att-edp-da-rg01-prod"
}

data "azurerm_mssql_server" "prod-sql-server" {
  name = "att-edp-da-sql01-dw-prod"
  resource_group_name = data.azurerm_resource_group.prod-rg.name
}

data "azurerm_storage_account" "rawADLS" {
  name = "attedpdadls01rawprod"
  resource_group_name = data.azurerm_resource_group.prod-rg.name
}

data "azurerm_storage_account" "lndADLS" {
  name = "attedpdadls01lndprod"
  resource_group_name = data.azurerm_resource_group.prod-rg.name
}

data "azurerm_user_assigned_identity" "m_id" {
  name = "att-edp-da-id01-cr01-prod"
  resource_group_name = data.azurerm_resource_group.prod-rg.name
}
# //---------------------------- ACI -------------------------------------------
module "aci_instance" {
  source = "../modules/ACI"
  name = "${var.prefix}-${var.aci_name}-${var.env}001"
  rg_name = data.azurerm_resource_group.prod-rg.name
  rg_locat = data.azurerm_resource_group.prod-rg.location
  cont = "${var.prefix}-${var.aci_cont}-${var.env}001"
  img = var.aci_img
  aci_subnet = module.internal_vnet.container_subnet_details
  server = data.azurerm_container_registry.edp_acr.login_server
  username = data.azurerm_container_registry.edp_acr.admin_username
  password = data.azurerm_container_registry.edp_acr.admin_password
  sqlsrvr = data.azurerm_mssql_server.prod-sql-server
  keyvault = data.azurerm_key_vault.infra_base_kv
  acr_id = data.azurerm_container_registry.edp_acr.id
  # storage_account = module.log_analytics.log_storage
}

# //---------------------------- Azure Data Factory -------------------------------------------
module "adf" {
  source = "../modules/ADF"

  name = "${var.prefix}-${var.adf_name}-${var.env}001"
  rg_name = data.azurerm_resource_group.prod-rg.name
  rg_locat = data.azurerm_resource_group.prod-rg.location
  sql_server = data.azurerm_mssql_server.prod-sql-server
  az_ir = var.az_ir_name_full
  aci = module.aci_instance.aci
  raw_id = data.azurerm_storage_account.rawADLS.id
  land_id = data.azurerm_storage_account.lndADLS.id
  rg = data.azurerm_resource_group.prod-rg
  keyvault = data.azurerm_key_vault.infra_base_kv
}

# # //---------------------------- Virtual Networks -------------------------------------------
module "internal_vnet" {
  source = "../modules/Internal_Vnet"

  name = "${var.prefix}-${var.internal_vnet_name}-${var.env}"
  rg_name = data.azurerm_resource_group.prod-rg.name
  rg_locat = data.azurerm_resource_group.prod-rg.location
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
