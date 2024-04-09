# Azure Data Lake Storage Gen2 for raw data in the main resource group
resource "azurerm_storage_account" "dlsRaw" {
  name                     = var.name  
  resource_group_name      = var.rg_name
  location                 = var.rg_locat
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled = true

  blob_properties {
    last_access_time_enabled = true
    delete_retention_policy {
      days = 5
    }
  }
}

resource "azurerm_storage_container" "log_container" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.dlsRaw.name
  container_access_type = "private"  
}
resource "azurerm_storage_container" "raw_container" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.dlsRaw.name
  container_access_type = "private"  
}
resource "azurerm_storage_container" "staging_container" {
  name                  = "staging"
  storage_account_name  = azurerm_storage_account.dlsRaw.name
  container_access_type = "private"  
}
resource "azurerm_storage_container" "web_container" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.dlsRaw.name
  container_access_type = "private"  
}

output "dlsraw" {
  value = azurerm_storage_account.dlsRaw
}