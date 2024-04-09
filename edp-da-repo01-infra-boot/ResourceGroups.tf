# Resource Group for Dev
resource "azurerm_resource_group" "dev_rg" {
  name     = "${var.prefix}-${var.project}-${var.rg_name}-dev"
  location = var.rg_location
}

# Resource Group for Tst
resource "azurerm_resource_group" "tst_rg" {
  name     = "${var.prefix}-${var.project}-${var.rg_name}-tst"
  location = var.rg_location
}

# Resource Group for Prod
resource "azurerm_resource_group" "prod_rg" {
  name     = "${var.prefix}-${var.project}-${var.rg_name}-prod"
  location = var.rg_location
}