// ##########################
// Start of General Resources

resource "random_string" "rand" {
  length  = 12
  special = false
  keepers = {

  }
}

resource "azurerm_resource_group" "main" {
  name     = var.resourcegroupname
  location = var.location
  tags     = var.taglist
}

// ########################
// End of General Resources


// ###################
// Start of Networking

resource "azurerm_virtual_network" "main" {
  name                = "${var.resourcegroupname}-network"
  address_space       = local.prefixes
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.taglist
}

resource "azurerm_subnet" "Frontend" {
  name                 = var.network_subnet_Frontend_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(local.lcidr, 8, 1)]

}

resource "azurerm_subnet" "Backend" {
  name                 = var.network_subnet_Backend_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(local.lcidr, 8, 2)]

}

// #################
// End of Networking


// ##############################
// Start of Network and Public IP

resource "azurerm_network_interface" "main" {
  for_each            = toset(local.counting)
  name                = "${each.key}-NIC"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.Frontend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main[each.key].id
  }
  tags = var.taglist
}

resource "azurerm_public_ip" "main" {
  for_each            = toset(local.counting)
  name                = "${each.key}-PIP"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  location            = azurerm_resource_group.main.location
  domain_name_label   = lower("${each.key}-dn")
  tags                = var.taglist
}

// #################################
// End of Network Card and Public IP


// ########################
// Start of Virtual Machine

resource "azurerm_windows_virtual_machine" "windows" {
  for_each            = toset(local.counting)
  name                = each.key
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vmsize
  eviction_policy     = var.priority == "Spot" ? var.eviction_policy : null
  priority            = var.priority
  admin_username      = /* data.azurerm_key_vault_secret.secret_Default-Admin-Windows-Linux-VM-Username.value */ var.admin_username
  admin_password      = /* data.azurerm_key_vault_secret.secret_Default-Admin-Windows-Linux-VM-Password.value */ var.admin_password
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
  //Remove Virtual Machine from Azure DSC when destroying.
provisioner "local-exec" {
    when = destroy
    command = "Get-AzAutomationDscNode -ResourceGroupName AzureAutomation -AutomationAccountName \"AzureAutomation\" -Name ${self.name} | Unregister-AzAutomationDscNode -force"
    interpreter = ["pwsh", "-Command"]
  } 

/* provisioner "local-exec" {
    when = destroy
    command = "Write-Host \"Hello Russ\""
    interpreter = ["pwsh", "-Command"]
  }   */

/*   provisioner "remote-exec" {
    connection {
      user     = "${var.admin_username}"
      password = "${var.admin_password}"
      port     = 5986
      https    = true
      timeout  = "10m"

      # NOTE: if you're using a real certificate, rather than a self-signed one, you'll want this set to `false`/to remove this.
      insecure = true
    }

    inline = [
      "cd C:\\Windows",
      "dir",
    ]
  } */

}

// ######################
// End of Virtual Machine


// ######################
// Start of Managed Disks

  resource "azurerm_managed_disk" "main" {
  for_each = ({for disk in local.datadisk_lun_map : disk.datadisk_name => disk})

  name                 = each.key
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = each.value.storage_account_type 
  create_option        = each.value.create_option        
  disk_size_gb         = each.value.disk_size_gb         
  tags                 = var.taglist
} 
  
  resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each = ({for attach in local.datadisk_lun_map : attach.datadisk_name => attach})
  managed_disk_id    = azurerm_managed_disk.main[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows[element(split("_", each.key),0)].id
  lun                = each.value.lun
  caching            = "ReadWrite"
}   

// ####################
// End of Managed Disks


// ##################
// Start of Key Vault

data "azurerm_resource_group" "rg_keyvault" {
  for_each = var.key_vault
  name = each.value["key_vault_resource_group"]
}

data "azurerm_key_vault" "keyvault" {
  for_each            = var.key_vault
  name                = each.value["key_vault_name"]
  resource_group_name = each.value["key_vault_resource_group"]
}
/*
data "azurerm_key_vault_secret" "secret_Default-Admin-Windows-Linux-VM-Username" {
  //count = var.use_existing_keyvault && !var.secret_password_only ? 1 : 0
  name = var.keyvault_secret_username 
  key_vault_id = data.azurerm_key_vault.keyvault.id
  
}

data "azurerm_key_vault_secret" "secret_Default-Admin-Windows-Linux-VM-Password" {
  //count = var.use_existing_keyvault ? 1 : 0
  name = var.keyvault_secret_password
  key_vault_id = data.azurerm_key_vault.keyvault.id
  
}
 */
// ################
// End of Key Vault

/* resource "azurerm_virtual_machine_extension" "IaaSAntimalware" {
for_each = toset(local.counting)
name = "MicrosoftAnitMalware"
virtual_machine_id = azurerm_windows_virtual_machine.windows[each.key].id
publisher = "Microsoft.Azure.Security"
type = "IaaSAntimalware"
type_handler_version = "1.5"
auto_upgrade_minor_version = true

settings = <<SETTINGS
{
"AntimalwareEnabled": "true",
"RealtimeProtectionEnabled": "true",
"ScheduledScanSettings": {
"isEnabled": "true",
"day": "1",
"time": "120",
"scanType": "Quick"
},
"Exclusions": {
"Extensions": "",
"Paths": "",
"Processes": ""
}
}
SETTINGS

tags                 = var.taglist
} */

/* 
resource "azurerm_virtual_machine_extension" "CustomScript" {
for_each = toset(local.counting)
name = each.key
virtual_machine_id = azurerm_windows_virtual_machine.windows[each.key].id
publisher = "Microsoft.Azure.Extensions"
type = "CustomScript"
type_handler_version = "2.0"
auto_upgrade_minor_version = true

settings = <<SETTINGS
{

}
SETTINGS

tags                 = var.taglist
} */


/* resource "azurerm_virtual_machine_extension" "CustomScript" {
for_each = toset(local.counting)
name = "${each.key}_CustomScriptExtension"
virtual_machine_id = azurerm_windows_virtual_machine.windows[each.key].id
publisher = "Microsoft.Compute"
type = "CustomScriptExtension"
type_handler_version = "1.9"
auto_upgrade_minor_version = true


  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./chocolatey.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://gist.githubusercontent.com/mcasperson/c815ac880df481418ff2e199ea1d0a46/raw/5d4fc583b28ecb27807d8ba90ec5f636387b00a3/chocolatey.ps1"
        ]
    }
  SETTINGS

tags                 = var.taglist
} */

/* resource "azurerm_virtual_machine_extension" "DSC_nonservice" {
for_each = toset(local.counting)
name = "${each.key}_DSC_nonservice"
virtual_machine_id = azurerm_windows_virtual_machine.windows[each.key].id
publisher = "Microsoft.Powershell"
type = "DSC"
type_handler_version = "2.77"
auto_upgrade_minor_version = true
depends_on = [azurerm_virtual_machine_data_disk_attachment.main]

  protected_settings = <<PROTECTED_SETTINGS
    {
    	"configurationUrlSasToken": "?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-10-09T17:05:02Z&st=2020-09-23T09:05:02Z&spr=https&sig=N4la%2Fn6L3zKA2wwR1jmU4BnHDO%2FQQ5yjP%2FTAeGUttJQ%3D"
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
      "wmfVersion": "latest",
              "configuration": {
                  "url": "https://terrysa.blob.core.windows.net/dsccontainer/PowershellDSC.ps1.zip",
                  "script": "PowershellDSC.ps1",
                  "function": "PowershellDSC"
              },
              "privacy": {
                  "dataCollection": "enable"
              },
            "advancedOptions": {
            "forcePullAndApply": false
            }   
    }
  SETTINGS

tags                 = var.taglist
} */

resource "azurerm_virtual_machine_extension" "DSC_service" {
for_each = toset(local.counting)
name = "${each.key}_DSC_service"
virtual_machine_id = azurerm_windows_virtual_machine.windows[each.key].id
publisher = "Microsoft.Powershell"
type = "DSC"
type_handler_version = "2.77"
auto_upgrade_minor_version = true
depends_on = [azurerm_virtual_machine_data_disk_attachment.main]

  protected_settings = <<PROTECTED_SETTINGS
    {
    	 "configurationArguments": {
        "RegistrationKey": {
            "userName": "NOT_USED",
            "Password": "${var.RegistrationKeyPassword}"
        }
    } 
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
    "configurationArguments": {
        "RegistrationUrl" : "${var.RegistrationUrl}",
        "NodeConfigurationName" : "${var.NodeConfigurationName}",
        "ConfigurationMode": "${var.ConfigurationMode}",
        "ConfigurationModeFrequencyMins": ${var.ConfigurationModeFrequencyMins},
        "RefreshFrequencyMins": ${var.RefreshFrequencyMins},
        "RebootNodeIfNeeded": ${var.RebootNodeIfNeeded},
        "ActionAfterReboot": "${var.ActionAfterReboot}",
        "AllowModuleOverwrite": ${var.AllowModuleOverwrite}
    }
}
  SETTINGS

tags                 = var.taglist
}

  #Remove Virtual Machine from Azure DSC when destroying.
/*   provisioner "local-exec" {
    when = destroy
    command = <<EOT
        $params = @{
        AutomationAccountName = "${var.azure_automation_account}"
        ResourceGroupName = "${var.azure_automation_account_resource_group}"
        }
        Get-AzAutomationDscNode -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name "${self.name}" | Unregister-AzAutomationDscNode -force
    EOT
   interpreter = ["pwsh", "-Command"]
  } */

/* resource "azurerm_virtual_machine_extension" "joindomain" {
  count = var.compute_instance_count
  name                 = "joindomain" 
  virtual_machine_id   = element(azurerm_virtual_machine.compute.*.id, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
      {
        "Name": "EXAMPLE.COM",
        "User": "EXAMPLE.COM\\azureuser",
        "Restart": "true",
        "Options": "3"
      }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "F@ncyP@ssw0rd"
    }
PROTECTED_SETTINGS
}
 */