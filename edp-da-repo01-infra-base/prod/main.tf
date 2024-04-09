provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "prod_rg" {
  name = "att-edp-da-rg01-prod"
}

//----------------------- ACR -----------------------
module "acr_module" {
  source = "../modules/Container_Registry"

  prefix = var.prefix
  env = var.env
  aci_cr_name = var.acr
  rg_name  = data.azurerm_resource_group.prod_rg.name
  rg_locat = data.azurerm_resource_group.prod_rg.location
}

//----------------------- SQL SERVER & DBs -----------------------
module "sql_server_module" {
  source = "../modules/SQL_Server"
  
  prefix = var.prefix
  env = var.env
  rg_name  = data.azurerm_resource_group.prod_rg.name
  rg_locat = data.azurerm_resource_group.prod_rg.location
  sql_server_name = var.sql_server_name
  dcs_database = var.dcs_db
  sn_database = var.sn_db
  username = var.server_username
  pass = var.server_pass
}

//---------------------------- Storage Accounts -------------------------------------------
module "raw_adls" {
  source = "../modules/Raw_Storage_Account"

  name = var.raw_adls_name
  rg_name = data.azurerm_resource_group.prod_rg.name
  rg_locat = data.azurerm_resource_group.prod_rg.location
}

module "lnd_ADLS" {
  source = "../modules/Lnd_Storage_Account"

  name = var.lnd_adls_name
  rg_name = data.azurerm_resource_group.prod_rg.name
  rg_locat = data.azurerm_resource_group.prod_rg.location
}

 //---------------------------- Managed Identity -------------------------------------------

module "managed_iden" {
  source = "../modules/Managed_Identity"

  prefix = var.prefix
  env = var.env
  name = var.m_id_name
  rg_name = data.azurerm_resource_group.prod_rg.name
  rg_locat = data.azurerm_resource_group.prod_rg.location
  acr_id = module.acr_module.acr.id
}