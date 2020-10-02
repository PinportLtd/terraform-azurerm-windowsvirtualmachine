

variable "taglist" {
  type        = map(string)
  description = "This is the tags for the Virtual Machine"
  default = {
    "Environment" = "Staging"
    "Created By"  = "Russell Maycock"
    "testing"     = "tested"
  }
}


variable "location" {
  description = "The Azure location of the virtual machine"
  default     = "uksouth"
}

variable "resourcegroupname" {
  description = "The Resource Group Name"
  default     = "Deathrace2000" // this needs to be set back to empty
}


// network variables

variable "network_subnet_name" {
  type        = list(string)
  description = "This is the names of the "
  default     = ["FrontEnd", "BackEnd"]
}

variable "network_address_prefixes" {

  description = "This is the subnet addresses"
  default     = [1, 2]
}

variable "network_subnets" {
  description = "a map of networks"
  type = map(object({
    subnet_name   = string
    subnet_prefix = list(string)

  }))
  default = {
    network1 = {
      subnet_name   = "FrontEnd"
      subnet_prefix = ["10.0.1.0/24"]
    },
    network2 = {
      subnet_name   = "BackEnd"
      subnet_prefix = ["10.0.2.0/24"]
    }
  }

}

variable "network_subnet_Frontend_name" {
  type        = string
  description = "a list of network names"
  default     = "Frontend"
}

variable "network_subnet_Backend_name" {
  type        = string
  description = "a list of prefixes"
  default     = "Backend"
}

variable "network_subnets3" {
  description = "Description"
  default = {
    "Frontend" = 1
    "Backend"  = 2
  }
}

variable "use_random_names" {
  type        = bool
  description = "Use a random name for the virtual machine"
  default     = true
}



variable "name_counts" {
  type = map(number)
  default = {
    "foo" = 1
    /*"bar" = 4 */
  }
}


// Virtul machine variables

variable "admin_password" {
  description = "This is the Administrator's Password. Use If you are not storing the password in a key vault. This should only be used for testing."
  default     = "Prophetzero4@"
}

variable "admin_username" {
  description = "This is the Administrator's Username. Use if you are not storing the Username in a key vault. This should only be used for testing."
  default     = "pinport"
}

variable "enable_automatic_updates" {
  description = "DescriptionSpecifies if Automatic Updates are Enabled for the Windows Virtual Machine. Changing this forces a new resource to be created"
  default     = true
}

variable "eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is Deallocate. Changing this forces a new resource to be created"
  default     = "Deallocate"
}

variable "priority" {
  description = "Specifies the priority of this Virtual Machine. Possible values are Regular and Spot. Defaults to Regular. Changing this forces a new resource to be created."
  default     = "Regular"
  validation {
    condition     = var.priority == "Regular" || var.priority == "Spot"
    error_message = "The priority variable must be set to Regular or Spot."
  }
}

variable "vmsize" {
  description = "The size of the Virtual Machine https://azure.microsoft.com/en-gb/pricing/details/virtual-machines/windows/#ddv4-series"
  default     = "Standard_B2ms"
}

variable "timezone" {
  description = "the timezone that the virtual machine should be in"
  default     = "GMT Standard Time"
  validation {
    condition     = var.timezone == "GMT Standard Time" || var.timezone == "Dateline Standard Time" || var.timezone == "UTC-11"
    error_message = "The Timezone is wrong, it must match one of the timezones in this list http://realworldit.net/2020/09/07/avaliable-timezones-for-azure-virtual-machines-in-terraform/ ."
  }
}

// Virtual machine identity block variables

variable "identity_type" {
  description = "The type of Managed Identity which should be assigned to the Windows Virtual Machine. Possible values are SystemAssigned, UserAssigned"
  default     = "SystemAssigned"
}

// Virtual machine identity block variables end


// Virtual Machine os_disk block variables

variable "caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite"
  default     = "ReadWrite"
  validation {
    condition     = var.caching == "None" || var.caching == "ReadOnly" || var.caching == "ReadWrite"
    error_message = "The caching for the os_disk must be set to one of the following None, ReadOnly or ReadWrite."
  }
}

variable "storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS. Changing this forces a new resource to be created."
  default     = "Standard_LRS"
  validation {
    condition     = var.storage_account_type == "Standard_LRS" || var.storage_account_type == "StandardSSD_LRS" || var.storage_account_type == "Premium_LRS"
    error_message = "The type of storeage account for the Internal OS Disk must be one of the following Standard_LRS, StandardSSD_LRS and Premium_LRS."
  }
}

// Virtual machine os_disk block variable ends


// Virtual machine secret block variable starts

variable "secrets" {
  description = "Description"
  type = map(object({
    store = string
    url   = string

  }))
  default = {

    secrets1 = {
      store = "My"
      url   = "https://pinportkv50.vault.azure.net/secrets/foomachines/fa7834184f5640f9b38aefd434d6e113"

    }

  }
}

// Virtual machine secret block variable ends


// Virtual machine source_image_reference block variables

variable "imagepublishername" {
  description = "The Publisher Name of the Image e.g. MicrosoftWindowsServer"
  default     = "MicrosoftWindowsServer"
}

variable "imageoffer" {
  description = "The Offer of the Image e.g. WindowsServer"
  default     = "WindowsServer"
}

variable "imagesku" {
  description = "The Sku of the image e.g. 2019-Datacenter"
  default     = "2019-Datacenter"
}

variable "imageskuversion" {
  description = "The version of the Sku e.g. latest"
  default     = "latest"
}

// Virtual Machine Image Variables End


//Virtual machine Win_rm block variables

variable "enable_winrm" {
  description = "If you don't have a certificate ready and do not want Win_rm on. I wouldn't recommend using it without HTTPS"
  default = {
    "Https" = "https://pinportkv50.vault.azure.net/secrets/foomachines/fa7834184f5640f9b38aefd434d6e113"
  }
}

// Virtual machine Win_rm block variables end

variable "boot_diagnostics_storage_account_uri" {
    description = "The URI of the storage account which is going to hold the boot diags"
    default     = {
     // "uri" = ""
    }
}

// Virtual Machine Variables End
// #############################





// ##################
// Key vault Settings

variable "keyvault_secret_username" {

  description = "The variable that holds the username of the virtual machine"
  default     = "Default-Admin-Windows-Linux-VM-Username"
}

variable "keyvault_secret_password" {

  description = "The variable that holds the password of the virtual machine"
  default     = "Default-Admin-Windows-Linux-VM-Password"
}


variable "key_vault" {
  description = "Description"
  type = map(object({
    key_vault_resource_group = string
    key_vault_name           = string


  }))
  default = {

    key_vault = {
      key_vault_resource_group = "keyvault"
      key_vault_name           = "russkv"

    }

  }
}

// end of key vault variables
// ##########################


// ##########################
// start of managed disk variables

variable "disks_per_vm" {
    description = "The amount of data disks for each virtual machine."
    default     = 1
}

variable "disksize" {
    description = "The size of the data disks for each virtual machine, currently they have to be the same size."
    default     = 32
}
// end of key vault variables
// ##########################
locals {
  
  vmname   = random_string.rand.result
  
  prefixes = ["10.0.0.0/16"]
  
  lcidr    = "10.0.0.0/16"
  
  counting = flatten(values(local.expanded_names))

  expanded_names = {
    for name, count in var.name_counts : name => [
      for i in range(count) : format("%s%02d", name, i)
    ]
  }
datadisk_count_map = { for k in local.counting : k => var.disks_per_vm}


  datadisk_lun_map = flatten([
    for vm_name, count in local.datadisk_count_map : [
      for i in range(count) : {
        datadisk_name = format("%s_datadisk%02d", vm_name, i)
        lun           = i
        storage_account_type = "Standard_LRS"
        create_option        = "Empty"
        disk_size_gb         = var.disksize
      }
    ]
  ])
// luns                      = { for k in local.datadisk_lun_map : k.datadisk_name => k.lun }

disksizes = {
  P1 = 4
  P2 = 8
  P3 = 16
  P4 = 32
  P6 = 64
  P10 = 128
  P15 = 256
  P20 = 512
  P30 = 1024
  P40 = 2048
  P50 = 4096
  P60 = 8192
  P70 = 16384
  P80 = 32767 
}
}
variable "powershellscriptfile" {
    description = "the name of the file to run"
    default     = "powershelltest.ps1"
}

variable "azure_automation_account" {
    description = "The name of the Azure Automation Account."
    default     = "AzureAutomation"
}

variable "azure_automation_account_resource_group" {
    description = "The Resource Group where the Azure Automation Account exists."
    default     = "AzureAutomation"
}


variable "RegistrationKeyPassword" {
    description = "The primary or secondary key of the Azure Automation. This can be obtained using the following commands $account = Get-AzAutomationAccount -ResourceGroupName azureautomation -name azureautomation  ,  $reginfo = $Account | Get-AzAutomationRegistrationInfo"
    default     = "gRHraf2iHMYqVPC6pf78f3g7BeR0t+u+pwwLaBO4Pgjf0uzKRK1pR3gIU9m6EXGuEoN4MOKUduQ2NsLKeS376w=="
}
variable "RegistrationUrl" {
    description = "Description"
    default     = "https://7f4ae278-9c1e-40c7-a946-eb0fa7896a21.agentsvc.uks.azure-automation.net/accounts/7f4ae278-9c1e-40c7-a946-eb0fa7896a21"
}
variable "NodeConfigurationName" {
    description = "The full name of the complied configuration to run, e.g. PowerShellDSC.localhost"
    default     = "PowerShellDSC.localhost"
}

variable "ConfigurationMode" {
    description = "Description"
    default     = "ApplyAndAutoCorrect"
}
variable "ConfigurationModeFrequencyMins" {
    description = "Description"
    default     = 15
}

variable "RefreshFrequencyMins" {
    description = "Description"
    default     = 30
}
variable "RebootNodeIfNeeded" {
    description = "Description"
    default     = true
}
variable "ActionAfterReboot" {
    description = "Description"
    default     = "continueConfiguration"
}

variable "AllowModuleOverwrite" {
    description = "Description"
    default     = true
}

