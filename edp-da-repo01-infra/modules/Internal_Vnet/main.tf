resource "azurerm_virtual_network" "internal_vnet" {
  name                = var.name
  location            = var.rg_locat
  resource_group_name = var.rg_name
  address_space       = var.vnet_address 
}

resource "azurerm_subnet" "internal_subnet" {
  name                 = var.internal_snet
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.internal_vnet.name
  address_prefixes     = var.snet_address
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry", "Microsoft.AzureActiveDirectory", "Microsoft.Sql", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "container_subnet" {
  name                 = "att-edp-da-snet01-aci-dev"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.internal_vnet.name
  address_prefixes     = var.container_snet_address
  delegation {
    name = "ACI Delegation"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

output "internal_vnet_details" {
  value = azurerm_virtual_network.internal_vnet
}

output "container_subnet_details" {
  value = azurerm_subnet.container_subnet
}

output "internal_subnet_details" {
  value = azurerm_subnet.internal_subnet
}
