variable "name" {
  description = "Log Aanlytics workspace"
}

variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_locat" {
  description = "Referenced Resource Group Location"
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account for Log Analytics"
  type        = string
}

variable "sku" {
  description = "Pricing tier for Log Analytics"
  type        = string
  default     = "PerGB2018"
}