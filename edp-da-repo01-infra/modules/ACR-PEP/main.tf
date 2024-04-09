# Define private DNS zone for SQL Server
resource "azurerm_private_dns_zone" "private_dns_acr" {
  name                = var.dns
  resource_group_name = var.rg_name
}
# Link private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_network_link" {
  name                  = var.vlink
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_acr.name
  virtual_network_id    = var.internal_vnet.id
  depends_on = [azurerm_private_dns_zone.private_dns_acr]
}
# Create private endpoint for acr
resource "azurerm_private_endpoint" "acr_endpoint" {
  name                = var.endpoint
  resource_group_name = var.rg_name
  location            = var.rg_locat
  subnet_id           = var.acr_subnet_id
  private_service_connection {
    name                           = "acr-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = var.acr.id
    subresource_names              = ["registry"]
    }
  private_dns_zone_group {
    name                 = "acr-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_acr.id]
  }
}

#Creata Private A record for DNS Zone
resource "azurerm_private_dns_a_record" "adf_dns_record" {
  name                = "acr_server_a_record"
  zone_name           = azurerm_private_dns_zone.private_dns_acr.name 
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_endpoint.private_service_connection.0.private_ip_address]
}
