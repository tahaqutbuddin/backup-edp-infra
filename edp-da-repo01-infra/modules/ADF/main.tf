data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {
}

resource "azurerm_data_factory" "adf1" {
    managed_virtual_network_enabled = true
    name                            = var.name
    resource_group_name             = var.rg_name
    location                        = var.rg_locat
    identity {
        type  = "SystemAssigned"
    }
}

resource "azurerm_data_factory_integration_runtime_azure" "ADF_IR" {
  name                    = var.az_ir
  data_factory_id         = azurerm_data_factory.adf1.id
  location                = "AutoResolve"
  virtual_network_enabled = true
}

resource "azurerm_data_factory_managed_private_endpoint" "adf-msssql-pe" {
  name               = "adfmssqlpe"
  data_factory_id    = azurerm_data_factory.adf1.id
  target_resource_id = var.sql_server.id
  subresource_name   = "sqlServer"
}

resource "azurerm_data_factory_managed_private_endpoint" "adf-adlsraw-pe" {
  name               = "adfadlsrawpe"
  data_factory_id    = azurerm_data_factory.adf1.id
  target_resource_id = var.raw_id
  subresource_name   = "dfs"
}

resource "azurerm_data_factory_managed_private_endpoint" "adf-adlsland-pe" {
  name               = "adfadlslandpe"
  data_factory_id    = azurerm_data_factory.adf1.id
  target_resource_id = var.land_id
  subresource_name   = "dfs"
}

resource "azurerm_role_assignment" "sql_contributor" {
  principal_id            = azurerm_data_factory.adf1.identity[0].principal_id
  role_definition_name    = "Data Factory Contributor"
  scope                   =  var.rg.id
}

resource "azurerm_role_assignment" "sbd_contributor_raw" {
  principal_id            = azurerm_data_factory.adf1.identity[0].principal_id
  role_definition_name    = "Storage Blob Data Contributor"
  scope                   =  var.raw_id
}

resource "azurerm_role_assignment" "sbd_contributor_land" {
  principal_id            = azurerm_data_factory.adf1.identity[0].principal_id
  role_definition_name    = "Storage Blob Data Contributor"
  scope                   =  var.land_id
}

resource "azurerm_role_assignment" "container_contr" {
  principal_id            = azurerm_data_factory.adf1.identity[0].principal_id
  role_definition_name    = "DAContainerContributor"
  scope                   = var.rg.id
}

resource "azurerm_key_vault_access_policy" "adf-principal" {
  key_vault_id = var.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_data_factory.adf1.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]
}

resource "azurerm_monitor_diagnostic_setting" "logs_adf" {
  name               = "logs_adf"
  target_resource_id = azurerm_data_factory.adf1.id
  log_analytics_workspace_id = var.logs_workspace.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "ActivityRuns"
  }
  enabled_log {
    category = "PipelineRuns"
  }
  enabled_log {
    category = "SSISIntegrationRuntimeLogs"
  }

  enabled_log {
    category = "TriggerRuns"
  }

  metric {
    category = "AllMetrics"
  }
}


# Add the keyvault reader and key vault secrets user Moreover the get list also needs to be in the secret, not the key
# all networks 
# enabled. 
# storage blob data contributor to adf
# autoresolve should be there
# secret_permissions


output "adf" {
  value = azurerm_data_factory.adf1
}
