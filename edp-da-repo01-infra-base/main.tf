terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.78.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Include the environments
module "dev" {
  source = "./dev"
}

module "tst" {
  source = "./tst"
}

module "prod" {
  source = "./prod"
}