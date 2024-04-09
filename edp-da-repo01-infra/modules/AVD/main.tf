locals {
  powershell_command = "Set-AzVMExtension -ResourceGroupName ${var.rg_name} -Location ${var.rg_location} -VMName ${var.vm_name}"
}

resource "azurerm_virtual_desktop_host_pool" "vdpool" {
  location            = var.rg_location
  resource_group_name = var.rg_name

  name                     = var.host_pool_name #"att-edp-da-vdpool02"
  validate_environment     = false
  start_vm_on_connect      = true
  custom_rdp_properties    = "targetisaddjoined:i:1;drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;enablerdsaadauth:i:0"
  type                     = "Pooled"
  maximum_sessions_allowed = 2
  load_balancer_type       = "DepthFirst"
}

resource "time_rotating" "avd_registration_expiration" {
  rotation_days = var.expiration_days
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.vdpool.id
  expiration_date = time_rotating.avd_registration_expiration.rotation_rfc3339
}

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = var.rg_name
  location            = var.rg_location
  
  host_pool_id        = azurerm_virtual_desktop_host_pool.vdpool.id
  type                = "Desktop"
  name                = var.dag
  depends_on          = [azurerm_virtual_desktop_host_pool.vdpool, azurerm_virtual_desktop_workspace.workspace]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}


resource "azurerm_network_interface" "avd_vm_nic" {
  name                = var.avd_nic
  resource_group_name = var.rg_name
  location            = var.rg_location
 
  ip_configuration {
    name                          = "avd-ipconf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "avd_vm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  size                  = var.vm_size 
  provision_vm_agent = true
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.avd_vm_nic.id]
  computer_name = var.computer_name
  license_type          = "Windows_Client"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-10"
    sku       = "20h2-evd" #"win10-21h2-ent"
    version   = "latest"
  }

  depends_on = [ 
    azurerm_network_interface.avd_vm_nic
   ]
}

# resource "azurerm_virtual_machine_extension" "vmext_domain_join" {
#   name                       = "att-edp-da-domainJoin"
#   virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.id
#   publisher                  = "Microsoft.Compute"
#   type                       = "JsonADDomainExtension"
#   type_handler_version       = "1.3"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#       "Name": "${var.domain_name}",
#       "User": "tahashakir40_gmail.com#EXT#@saqibperwaizgmail.onmicrosoft.com",
#       "Restart": "true",
#       "Options": "3",
#       "JoinOptions": "1"  
#     }
# SETTINGS

#   lifecycle {
#     ignore_changes = [settings, protected_settings]
#   }
# }

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  name                       = "att-edp-da-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.vdpool.name}",
        "aadJoin": true
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_desktop_host_pool.vdpool
  ]
}


resource "azurerm_virtual_machine_extension" "vmext_network_watcher" {
  name                 = "AzureNetworkWatcher"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.id
  publisher            = "Microsoft.Azure.NetworkWatcher"
  type                 = "NetworkWatcherAgentWindows"
  type_handler_version = "1.4"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
 
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm
  ]
}


