// ##########################
// Start of General resources


// End of General resources
// ########################



// ############################
// Start of Key Vault resources

data "azurerm_resource_group" "rg_keyvault" {
  for_each = var.key_vault
  name     = each.value["key_vault_resource_group"]
}

data "azurerm_key_vault" "keyvault" {
  for_each            = var.key_vault
  name                = each.value["key_vault_name"]
  resource_group_name = each.value["key_vault_resource_group"]
}

data "azurerm_key_vault_secret" "secret_Default-Admin-VM-Password" {
  for_each     = var.key_vault
  name         = each.value["key_vault_secret_password"]
  key_vault_id = data.azurerm_key_vault.keyvault[each.key].id
}

// End of Key Vault resources
// ##########################



// #############################
// Start of Networking resources

resource "azurerm_virtual_network" "main" {
  name                = "${var.resourcegroupname}-network"
  address_space       = local.lcidr
  location            = var.location
  resource_group_name = var.resourcegroupname
  tags                = var.taglist
}

resource "azurerm_subnet" "main" {
  name                 = var.network_subnet_name
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(local.lcidr[0], 8, 1)]

}

// End of Networking resources
// ###########################



// ########################################
// Start of Network and Public IP resources

resource "azurerm_network_interface" "main" {
  for_each            = toset(local.counting)
  name                = "${each.key}-NIC"
  location            = var.location
  resource_group_name = var.resourcegroupname

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main[each.key].id
  }
  tags = var.taglist
}

resource "azurerm_public_ip" "main" {
  for_each            = toset(local.counting)
  name                = "${each.key}-PIP"
  resource_group_name = var.resourcegroupname // azurerm_resource_group.main.name
  allocation_method   = "Static"
  location            = var.location // azurerm_resource_group.main.location
  domain_name_label   = lower("${each.key}")
  tags                = var.taglist
}

// End of Network Card and Public IP resources
// ###########################################



// #################################
// Start of Virtual Machine resource

resource "azurerm_windows_virtual_machine" "windows" {
  for_each            = toset(local.counting)
  name                = each.key
  resource_group_name = var.resourcegroupname // azurerm_resource_group.main.name
  location            = var.location          // azurerm_resource_group.main.location
  size                = var.vmsize
  eviction_policy     = var.priority == "Spot" ? var.eviction_policy : null
  priority            = var.priority
  admin_username      = var.admin_username
  admin_password      = length(var.key_vault) == 0 ? var.admin_password : element([for keyvaultpassword in data.azurerm_key_vault_secret.secret_Default-Admin-VM-Password : keyvaultpassword.value], 0)
  network_interface_ids = [
    azurerm_network_interface.main[each.key].id,
  ]

  os_disk {
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.imagepublishername
    offer     = var.imageoffer
    sku       = var.imagesku
    version   = var.imageskuversion
  }
  tags                     = var.taglist
  timezone                 = var.timezone
  enable_automatic_updates = var.enable_automatic_updates

  dynamic "secret" {
    for_each = var.secrets

    content {
      certificate {
        store = secret.value["store"]
        url   = secret.value["url"]
      }
      key_vault_id = element([for keyvaultresource in data.azurerm_key_vault.keyvault : keyvaultresource.id], 0)
    }
  }

  dynamic "winrm_listener" {
    for_each = var.enable_winrm

    content {
      protocol        = winrm_listener.key
      certificate_url = winrm_listener.value
    }

  }

  identity {
    type = var.identity_type

  }

  dynamic boot_diagnostics {
    for_each = var.boot_diagnostics_storage_account_uri

    content {
      storage_account_uri = boot_diagnostics.value
    }
  }

}

// End of Virtual Machine resource
// ###############################



// ################################
// Start of Managed Disks resources

resource "azurerm_managed_disk" "main" {
  for_each = ({ for disk in local.datadisk_lun_map : disk.datadisk_name => disk })

  name                 = each.key
  location             = var.location          // azurerm_resource_group.main.location
  resource_group_name  = var.resourcegroupname // azurerm_resource_group.main.name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  tags                 = var.taglist
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each           = ({ for attach in local.datadisk_lun_map : attach.datadisk_name => attach })
  managed_disk_id    = azurerm_managed_disk.main[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows[element(split("_", each.key), 0)].id
  lun                = each.value.lun
  caching            = "ReadWrite"
}


// End of Managed Disks resources
// ##############################



// ###########################################################
// Start of Virtual Machine IaaSAntimalware Extension resource

resource "azurerm_virtual_machine_extension" "IaaSAntimalware" {
  for_each                   = var.enableIaaSAntiMalwareExtension == true ? toset(local.counting) : []
  name                       = "MicrosoftAnitMalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows[each.key].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
{
"AntimalwareEnabled": "${var.IaaSAntimalwareExt_AntimalwareEnabled}",
"RealtimeProtectionEnabled": "${var.IaaSAntimalwareExt_RealtimeProtectionEnabled}",
"ScheduledScanSettings": {
"isEnabled": "${var.IaaSAntimalwareExt_ScheduledScanSettings_isEnabled}",
"day": "${var.IaaSAntimalwareExt_ScheduledScanSettings_day}",
"time": "${var.IaaSAntimalwareExt_ScheduledScanSettings_time}",
"scanType": "${var.IaaSAntimalwareExt_ScheduledScanSettings_scanType}"
},
"Exclusions": {
"Extensions": "${var.IaaSAntimalwareExt_Exclusions_Extensions}",
"Paths": "${var.IaaSAntimalwareExt_Exclusions_Paths}",
"Processes": "${var.IaaSAntimalwareExt_Exclusions_Processes}"
}
}
SETTINGS

  tags = var.taglist
}

// End of Virtual Machine IaaSAntimalware Extension resource
// #########################################################



// ########################################################
// Start of Virtual Machine CustomScript Extension resource

resource "azurerm_virtual_machine_extension" "CustomScript" {
  for_each                   = var.enableCustomScriptextension == true ? toset(local.counting) : []
  name                       = "${each.key}_CustomScriptExtension"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true


  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "${var.CustomScriptExt_commandToExecute}"
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": ["${var.CustomScriptExt_filesUris}"]
    }
  SETTINGS

  tags = var.taglist
}

// End of Virtual Machine Custom Script Extension resource
// #######################################################



// ######################################################
// Start of Virtual Machine DSC Script Extension resource

resource "azurerm_virtual_machine_extension" "DSCScript" {
  for_each                   = (var.enableDSCScriptextension == true && var.enableDSCServiceextension == false) ? toset(local.counting) : []
  name                       = "${each.key}_DSCScript"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows[each.key].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.77"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_virtual_machine_data_disk_attachment.main]

  protected_settings = <<PROTECTED_SETTINGS
    {
    	"configurationUrlSasToken": "${var.DSCScriptExt_configurationUrlSasToken}"
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
      "wmfVersion": "latest",
              "configuration": {
                  "url": "${var.DSCScriptExt_Url}",
                  "script": "${var.DSCScriptExt_Name}",
                  "function": "${var.DSCScriptExt_Function}"
              },
              "privacy": {
                  "dataCollection": "${var.DSCScriptExt_dataCollection}"
              },
            "advancedOptions": {
            "forcePullAndApply": "${var.DSCScriptExt_forcePullAndApply}"
            }   
    }
  SETTINGS

  tags = var.taglist
}

// End of Virtual Machine DSC Script Extension resource
// ####################################################



// #######################################################
// Start of Virtual Machine DSC Service Extension resource

resource "azurerm_virtual_machine_extension" "DSCService" {
  for_each                   = (var.enableDSCServiceextension == true && var.enableDSCScriptextension == false) ? toset(local.counting) : []
  name                       = "${each.key}_DSCService"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows[each.key].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.77"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_virtual_machine_data_disk_attachment.main]

  protected_settings = <<PROTECTED_SETTINGS
    {
    	 "configurationArguments": {
        "RegistrationKey": {
            "userName": "NOT_USED",
            "Password": "${var.DSCServiceExt_RegistrationKeyPassword}"
        }
    } 
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
    "configurationArguments": {
        "RegistrationUrl" : "${var.DSCServiceExt_RegistrationUrl}",
        "NodeConfigurationName" : "${var.DSCServiceExt_NodeConfigurationName}",
        "ConfigurationMode": "${var.DSCServiceExt_ConfigurationMode}",
        "ConfigurationModeFrequencyMins": ${var.DSCServiceExt_ConfigurationModeFrequencyMins},
        "RefreshFrequencyMins": ${var.DSCServiceExt_RefreshFrequencyMins},
        "RebootNodeIfNeeded": ${var.DSCServiceExt_RebootNodeIfNeeded},
        "ActionAfterReboot": "${var.DSCServiceExt_ActionAfterReboot}",
        "AllowModuleOverwrite": ${var.DSCServiceExt_AllowModuleOverwrite}
    }
}
  SETTINGS

  tags = var.taglist
}

// End of Virtual Machine DSC Service Extension resource
// #####################################################

