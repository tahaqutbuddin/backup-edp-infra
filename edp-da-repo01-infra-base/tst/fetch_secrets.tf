data "azurerm_client_config" "current" {}

// Retrieve the Key Vault - infra_kv
data "azurerm_key_vault" "infra_kv" {
  name                = "att-edp-da-kv01-infra"
  resource_group_name = "att-edp-da-rg01-infra"
}

// Fetch all the secret keys within the specified Key Vault ending with "-TST"
data "azurerm_key_vault_secrets" "get_all" {
  key_vault_id = data.azurerm_key_vault.infra_kv.id
  depends_on   = [data.azurerm_key_vault.infra_kv]
}

// Filter and store only the secret keys that end with "-TST"
locals {
  dev_secret = [
    for secret in data.azurerm_key_vault_secrets.get_all.names : secret 
    if can(regex(".*-TST$", secret))
  ]
}

// Fetch values for the "-TST" secrets from infra_kv
data "azurerm_key_vault_secret" "original" {
  for_each = { for name in local.dev_secret : name => name }

  name         = each.key
  key_vault_id = data.azurerm_key_vault.infra_kv.id
}

//Create a new kv for the env
resource "azurerm_key_vault" "infra_base_kv" {
  name                       = "${var.prefix}-${var.infra_base_kv}-${var.env}"
  resource_group_name        = data.azurerm_resource_group.tst_rg.name
  location                   = data.azurerm_resource_group.tst_rg.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Set", "Get", "Delete", "Purge", "List","Recover", "Backup", "Restore"]
  }
}

//Add all the fetched secrets in the new key vault
resource "azurerm_key_vault_secret" "dev_secrets" {
  for_each = { for idx, secret_name in local.dev_secret : idx => secret_name }

  name         = replace(each.value, "-TST", "") 
  value        = data.azurerm_key_vault_secret.original[each.value].value
  key_vault_id = data.azurerm_key_vault.infra_base_kv.id
}
