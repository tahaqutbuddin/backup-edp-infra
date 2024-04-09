# terraform {
#   backend "azurerm" {
#     resource_group_name   = "att-edp-da-rg01-infra"
#     storage_account_name   = "attedpdadls"
#     container_name         = "attstatetf"
#     key                    = "infra/terraform.tfstate"
#   }
# }