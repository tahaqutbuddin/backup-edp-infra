resource "azurerm_storage_account" "logs" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.rg_locat
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "logs_analytics" {
  name                = var.name
  location            = var.rg_locat
  resource_group_name = var.rg_name
  sku                 = var.sku
  retention_in_days = 30  # Adjust as needed
  depends_on = [azurerm_storage_account.logs]
}

resource "azurerm_log_analytics_linked_storage_account" "linked_storage" {
  data_source_type      = "CustomLogs"
  resource_group_name   = var.rg_name
  workspace_resource_id = azurerm_log_analytics_workspace.logs_analytics.id
  storage_account_ids   = [azurerm_storage_account.logs.id]
}


output "log_storage" {
  value = azurerm_storage_account.logs
}

output "logs_analytics" {
  value = azurerm_log_analytics_workspace.logs_analytics
}
