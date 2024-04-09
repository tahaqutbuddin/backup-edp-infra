variable "service" {
  description = "Name of Service for which you need a Private endpoint"
}

variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_location" {
  description = "Referenced Resource Group Location"
}

variable "resource" {
  description = "Referenced Storage Account"
}

variable "dns_zone" {
  description = "Private DNS Zone Name"
}

variable "vlink" {
  description = "Private DNS zone Virtual Network Link"
}

variable "internal_vnet" {
  description = "Internal Virtual Network"
}

variable "subnet_id" {
  description = "ID of SA Subnet" 
}

variable "endpoint" {
  description = "Endpoint"
}

variable "subresource" {
  default = "Name of subresource for Pvt Service Connection"
}
