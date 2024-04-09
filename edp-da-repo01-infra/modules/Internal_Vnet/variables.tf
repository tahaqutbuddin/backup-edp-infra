variable "name" {
  description = "Name of the Internal Virtual Network"
}

variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_locat" {
  description = "Referenced Resource Group Location"
}

variable "internal_snet" {
  description = "Name of the Internal Subnet"
}
variable "vnet_address" {
  description = "VNET Address Space"
}
variable "snet_address" {
  description = "subnet Address space"
}
variable "container_snet_address" {
  description = "ACI subnet address space"
}