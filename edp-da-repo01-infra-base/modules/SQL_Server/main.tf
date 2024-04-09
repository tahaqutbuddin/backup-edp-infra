provider "azurerm" {
  features {}
}

resource "azurerm_mssql_server" "az_sql_server" {
  name                         = "${var.prefix}-${var.sql_server_name}-${var.env}"
  resource_group_name          = var.rg_name
  location                     = var.rg_locat
  version                      = "12.0"
  administrator_login          = var.username
  administrator_login_password = var.pass
  public_network_access_enabled = false
  identity{
    type = "SystemAssigned"
  }
}

# Azure SQL Database
resource "azurerm_mssql_database" "dcs_database" {
  name                = "${var.prefix}-${var.dcs_database}-${var.env}"
  server_id           = azurerm_mssql_server.az_sql_server.id
  sku_name            = "HS_Gen5_2"
}

resource "azurerm_mssql_database" "sn_database" {
  name                = "${var.prefix}-${var.sn_database}-${var.env}"
  server_id           = azurerm_mssql_server.az_sql_server.id
  sku_name            = "HS_Gen5_2"
}

resource "azurerm_monitor_diagnostic_setting" "logs_sql" {
  name               = "logs_sql"
  target_resource_id = azurerm_mssql_server.az_sql_server.id
  log_analytics_workspace_id = var.logs_workspace.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "ResourceUsageStats"
  }

  metric {
    category = "AllMetrics"
  }
}


