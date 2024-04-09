# Define private DNS zone for SQL Server
resource "azurerm_private_dns_zone" "private_dns_adf" {
  name                = var.dns
  resource_group_name = var.rg_name
}

# Link private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_network_link" {
  name                  = var.vlink
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_adf.name
  virtual_network_id    = var.internal_vnet.id
  depends_on            = [azurerm_private_dns_zone.private_dns_adf]
}

# Create private endpoint for ADF
resource "azurerm_private_endpoint" "adf_endpoint" {
  name                = var.endpoint
  resource_group_name = var.rg_name
  location            = var.rg_locat
  subnet_id           = var.adf_subnet_id

  private_service_connection {
    name                           = "adf-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = var.adf.id
    subresource_names              = ["dataFactory"]
    }

  private_dns_zone_group {
    name                 = "adf-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_adf.id]
  }
}


#Creata Private A record for DNS Zone
resource "azurerm_private_dns_a_record" "adf_dns_record" {
  name                = "adf_server_a_record"
  zone_name           = azurerm_private_dns_zone.private_dns_adf.name 
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.adf_endpoint.private_service_connection.0.private_ip_address]
}
