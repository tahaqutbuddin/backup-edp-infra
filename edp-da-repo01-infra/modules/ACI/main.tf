data "azurerm_client_config" "current" {}

resource "azurerm_container_group" "container_instance" {
  name                = var.name
  location            = var.rg_locat
  resource_group_name = var.rg_name
  os_type             = "Linux"
  identity {
        type  = "SystemAssigned"
    }

  container {
    name   = var.cont
    image  = var.img
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

    image_registry_credential {
    server   = var.server
    username = var.username
    password = var.password
  }

  diagnostics {
    log_analytics {
      workspace_id = var.logs_workspace.workspace_id
      workspace_key = var.logs_workspace.primary_shared_key
    }
  }

  ip_address_type = "Private"
  subnet_ids = [var.aci_subnet.id]
  restart_policy = "Never"
}

resource "azurerm_key_vault_access_policy" "aci-principal" {
  key_vault_id = var.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    =  azurerm_container_group.container_instance.identity[0].principal_id

  secret_permissions = ["Get","List"]
}

resource "azurerm_role_assignment" "sql_contributor" {
  principal_id            = azurerm_container_group.container_instance.identity[0].principal_id
  role_definition_name    = "Contributor"
  scope                   = var.sqlsrvr.id
}

resource "azurerm_role_assignment" "sql_db_contributor" {
  principal_id            = azurerm_container_group.container_instance.identity[0].principal_id
  role_definition_name    = "SQL DB Contributor"
  scope                   = var.sqlsrvr.id
}

resource "azurerm_role_assignment" "keyvault_reader" {
  principal_id            = azurerm_container_group.container_instance.identity[0].principal_id
  role_definition_name    = "Key Vault Reader"
  scope                   = var.keyvault.id
}

resource "azurerm_role_assignment" "keyvault_secrets_user" {
  principal_id            = azurerm_container_group.container_instance.identity[0].principal_id
  role_definition_name    = "Key Vault Secrets User"
  scope                   = var.keyvault.id
}

resource "azurerm_role_assignment" "keyvault_contributor" {
  principal_id            = azurerm_container_group.container_instance.identity[0].principal_id
  role_definition_name    = "Key Vault Contributor"
  scope                   = var.keyvault.id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope               = var.acr_id
  role_definition_name = "ACRPull"
  principal_id        = azurerm_container_group.container_instance.identity[0].principal_id
}

output "aci" {
  value = azurerm_container_group.container_instance
}