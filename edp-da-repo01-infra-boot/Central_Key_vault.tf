# Key vault
# Specify the key vault and the access policies
resource "azurerm_key_vault" "edp_kv" {
  name                        = "${var.prefix}-${var.project}-${var.key_vault}-infra"
  location                    = azurerm_resource_group.state_rg.location
  resource_group_name         = azurerm_resource_group.state_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Set", "Get", "Delete", "Purge", "List"]
  }
}
