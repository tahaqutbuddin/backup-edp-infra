terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.78.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group for Statetf file
resource "azurerm_resource_group" "state_rg" {
  name     = "${var.prefix}-${var.project}-${var.rg_name}-infra"
  location = var.rg_location
}

data "azurerm_client_config" "current" {}
