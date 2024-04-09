provider "azurerm" {
  features {}
}

# Azure Container Registry 
resource "azurerm_container_registry" "acr" {
  name                = var.aci_cr_name
  resource_group_name = var.rg_name
  location            = var.rg_locat
  sku                 = "Premium"
  admin_enabled       = true
  
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_monitor_diagnostic_setting" "logs_acr" {
  name               = "logs_acr"
  target_resource_id = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.logs_workspace.id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }
  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  metric {
    category = "AllMetrics"
  }
}

output "acr" {
  value = azurerm_container_registry.acr
}