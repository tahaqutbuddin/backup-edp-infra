variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_location" {
  description = "Referenced Resource Group Location"
}

variable "host_pool_name" {
  description = "Name of the Host Pool"
}

variable "expiration_days" {
  description = "Days for Pool to expire"
}

variable "workspace_name" {
  description = "Workspace Name"
}

variable "dag" {
  description = "Desktop Application Group Name"
}

variable "avd_nic" {
  description = "AVD Network Interface"
}

variable "admin_username" {
  description = "Username for Admin access to VM"
}

variable "admin_password" {
  description = "Password of Admin for access to VM"
}

variable "vm_name" {
  description = "Virtual Desktop's VM name"
}

variable "vm_size" {
  description = "Virtual Desktop's VM size"
}

variable "domain_name" {
  description = "Entra ID verified domain name"
}

variable "subnet_id" {
  description = "Subnet ID where network interface for VM needs to be created"
}

variable "computer_name" {
  description = "Name of Computer"
}