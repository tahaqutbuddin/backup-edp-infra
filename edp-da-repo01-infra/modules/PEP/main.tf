# Define private DNS zone
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.dns_zone
  resource_group_name = var.rg_name
}

# Link private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_network_link" {
  name                  = var.vlink
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.internal_vnet.id
  depends_on            = [azurerm_private_dns_zone.private_dns]
}

# Create private endpoint 
resource "azurerm_private_endpoint" "pvt_endpoint" {
  name                = var.endpoint
  resource_group_name = var.rg_name
  location            = var.rg_location
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "${var.service}-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = var.resource.id
    subresource_names              = ["${var.subresource}"]
    }

  private_dns_zone_group {
    name                 = "${var.service}-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns.id]
  }
}

#Creata Private A record for DNS Zone
resource "azurerm_private_dns_a_record" "dns_a_sta" {
  name                = "${var.service}_a_record"
  zone_name           = azurerm_private_dns_zone.private_dns.name 
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pvt_endpoint.private_service_connection.0.private_ip_address]
}
