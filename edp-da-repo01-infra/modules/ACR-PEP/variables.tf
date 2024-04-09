variable "rg_name" {
  description = "Referenced Resource Group Name"
}
variable "rg_locat" {
  description = "Referenced Resource Group Location"
}
variable "internal_vnet" {
  description = "Referenced Internal Virtual Network"
}
variable "acr" {
  description = "Referenced ACR"
}
variable "endpoint" {
  description = "Endpoint Name"
}
variable "dns" {
  description = "Private DNS Name"
}
variable "vlink" {
  description = "Private DNS zone Virtual Network Link"
}
variable "acr_subnet_id" {
  description = "ID of ACR Subnet" 
}