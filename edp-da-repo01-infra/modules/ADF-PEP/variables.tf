variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_locat" {
  description = "Referenced Resource Group Location"
}

variable "adf" {
  description = "Referenced Azure Data Factory"
}

variable "dns" {
  description = "Private DNS Name"
}

variable "vlink" {
  description = "Private DNS zone Virtual Network Link"
}

variable "adf_subnet_id" {
  description = "ID of ADF Subnet" 
}

variable "endpoint" {
  description = "Endpoint"
}

variable "internal_vnet" {
  description = "Internal Virtual Network"
}