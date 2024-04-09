variable "aci_cr_name" {
  description = "Container Registry Name"
}

variable "rg_name" {
  description = "Referenced Resource Group Name"
}

variable "rg_locat" {
  description = "Referenced Resource Group Location"
}

variable "prefix" {
  description = "Project prefix"
}


variable "env" {
 description = "Environment for Infrastructure"
}

variable "logs_workspace" {
  description = "Log Analytics Workspace id"
}
