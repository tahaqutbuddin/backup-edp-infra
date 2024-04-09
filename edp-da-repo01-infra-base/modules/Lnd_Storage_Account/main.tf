# Azure Data Lake Storage Gen2 for raw data in the main resource group
resource "azurerm_storage_account" "dlsLanding" {
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

resource "azurerm_storage_container" "landing_container" {
  name                  = "landing"
  storage_account_name  = azurerm_storage_account.dlsLanding.name
  container_access_type = "private"  
}

output "adls-lnd" {
  value = azurerm_storage_account.dlsLanding
}