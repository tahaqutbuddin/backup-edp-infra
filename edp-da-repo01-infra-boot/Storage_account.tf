# Storage Account for Statetf file
resource "azurerm_storage_account" "blobstorage" {
  name                      = var.storage_acc
  resource_group_name       = azurerm_resource_group.state_rg.name
  location                  = azurerm_resource_group.state_rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

# Container for Statetf file
resource "azurerm_storage_container" "env_state_container" {
  name                  = var.blob_container
  storage_account_name  = azurerm_storage_account.blobstorage.name
  container_access_type = "blob"
}