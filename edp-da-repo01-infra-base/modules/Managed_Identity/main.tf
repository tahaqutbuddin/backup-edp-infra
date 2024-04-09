data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "aci_managed_id" {
  location            = var.rg_locat
  name                = "${var.prefix}-${var.name}-${var.env}"
  resource_group_name = var.rg_name
}

# Assign the Managed Identity access to the Azure Container Registry
resource "azurerm_role_assignment" "acr_role_assignment" {
  principal_id            = azurerm_user_assigned_identity.aci_managed_id.principal_id
  role_definition_name    = "AcrPull"
  scope                   = var.acr_id
}

output "m_id" {
  value = azurerm_user_assigned_identity.aci_managed_id
}