// ##########################
// Start of General variables


// Required Variables


variable "location" {
  description = "The Azure location of the Resource Group."
}


variable "resourcegroupname" {
  description = "The Resource Group Name."
}


variable "admin_password" {
  description = "This is the Administrator's Password. Use If you are not storing the password in a key vault."
  default     = "PassWORD@123!DoNOTuseTHIS!AlthoughItIsSoLongMayBE1tWillBeOK!"
}


// Optional Variables


variable "taglist" {
  type        = map(string)
  description = "This is the tags for the project."
  default = {
    
  }
}


variable "name_counts" {
  type        = map(number)
  description = "The name and number of machines."
  default = {
    "foo" = 1
    // "bar" = 1
  }
}


// End of General variables
// ########################


// ##################
// Key vault Settings


variable "key_vault" {
  type = map(object({
    key_vault_resource_group  = string
    key_vault_name            = string
    key_vault_secret_password = string
  }))
  description = "Existing Key Vault Settings."
  default = {

  }
}


// end of key vault variables
// ##########################


// ##########################
// Start of Network variables


variable "network_subnet_name" {
  description = "The name of the subnet."
  default     = "Frontend"
}


// End of Network variables
// ########################


// #################################
// Start of Virtua Machine variables


variable "admin_username" {
  description = "The name of the Administrator."
  default     = "azureadmin"
}


variable "enable_automatic_updates" {
  description = "Enables auto updates on the VM/s."
  default     = true
}


variable "eviction_policy" {
  description = "Sets the eviction policy if the VM is set to use azure Spot. The only available option is to deallocate at the moment."
  default     = "Deallocate"
}


variable "priority" {
  description = "Set to either Regular or Spot. To use azure spot set to Spot."
  default     = "Regular"
}


variable "vmsize" {
  description = "The size of the VM/s."
  default     = "Standard_B2ms"
}


variable "timezone" {
  description = "The timezone for the VM/s."
  default     = "GMT Standard Time"
}


// Virtual Machine identity block variables


variable "identity_type" {
  description = "The identity type can be set to systemassigned or userassigned."
  default     = "SystemAssigned"
}


// Virtual Machine identity block variables end


// Virtual Machine os_disk block variables


variable "caching" {
  description = "The caching of the OS Disk."
  default     = "ReadWrite"
}


variable "storage_account_type" {
  description = "The storage account type can be one of three options."
  default     = "Standard_LRS"
}


// Virtual machine os_disk block variable ends


// Virtual machine secret block variable starts


variable "secrets" {
  type = map(object({
    store = string
    url   = string
  }))
  description = "Secrets are the certificates - see examples for help."
  default = {

  }
}


// Virtual machine secret block variable ends


// Virtual machine source_image_reference block variables


variable "imagepublishername" {
  description = "The publishers name of the image e.g. MicrosoftWindowsServer."
  default     = "MicrosoftWindowsServer"
}


variable "imageoffer" {
  description = "The offer of the image e.g. WindowsServer."
  default     = "WindowsServer"
}


variable "imagesku" {
  description = "The SKU of the image e.g. 2019-DataCenter."
  default     = "2019-DataCenter"
}


variable "imageskuversion" {
  description = "The version of the SKU of the image e.g. latest."
  default     = "latest"
}


// Virtual machine source_image_reference block variables End


// Virtual machine Win_rm block variables


variable "enable_winrm" {
  description = "Enables WinRM - see examples for help."
  default = {

  }
}


// Virtual machine Win_rm block variables end


// Virtual machine Boot Diags Block variables start


variable "boot_diagnostics_storage_account_uri" {
  description = "The URI of the storage account where you are storing the boot diags. - see examples for help."
  default = {

  }
}


// Virtual machine Boot Diags Block variables end


// Virtual Machine Variables End
// #############################


// ###############################
// start of Managed Disk variables


variable "disks_per_vm" {
  description = "Number of disk per VM."
  default     = 0
}


variable "disksize" {
  description = "The size of the disk in GB. This will apply to all Data Disks."
  default     = 32
}


// end of Managed Disk variables
// #############################


// ############################################
// Start of IaaSAntiMalware Extension variables
// for help - https://docs.microsoft.com/en-us/azure/security/fundamentals/antimalware

variable "enableIaaSAntiMalwareExtension" {
  description = "Enables the IaaSAntiMalware extension."
  default     = false
}


variable "IaaSAntimalwareExt_AntimalwareEnabled" {
  description = "Enables the antimalware in the extension."
  default     = "true"
}


variable "IaaSAntimalwareExt_RealtimeProtectionEnabled" {
  description = "Enables the antimalware realtime protection."
  default     = "true"
}


variable "IaaSAntimalwareExt_ScheduledScanSettings_isEnabled" {
  description = "Enables the scheduled scan."
  default     = "true"
}


variable "IaaSAntimalwareExt_ScheduledScanSettings_day" {
  description = "Set the Day settings."
  default     = "1"
}


variable "IaaSAntimalwareExt_ScheduledScanSettings_time" {
  description = "Set the Scan time."
  default     = "120"
}


variable "IaaSAntimalwareExt_ScheduledScanSettings_scanType" {
  description = "Which Scan Type to run."
  default     = "Quick"
}


variable "IaaSAntimalwareExt_Exclusions_Extensions" {
  description = "List of file extensions to exclude."
  default     = ""
}


variable "IaaSAntimalwareExt_Exclusions_Paths" {
  description = "List of files or paths to exclude."
  default     = ""
}


variable "IaaSAntimalwareExt_Exclusions_Processes" {
  description = "List of process to exclude."
  default     = ""
}


// End of IaaSAntimalware Extension variables
// ##########################################


// #########################################
// Start of CustomScript Extension variables


variable "enableCustomScriptextension" {
  description = "Enable the Custom Script extension."
  default     = false
}


variable "CustomScriptExt_commandToExecute" {
  description = "The command to run e.g. powershell.exe -Command ./chocolatey.ps1; exit 0; ."
  default     = ""
}


variable "CustomScriptExt_filesUris" {
  description = "The location URL of the script to run e.g. https://gist.githubusercontent.com/Russtym/29dd88d6b14af89a715646c73bd03c38/raw/61e9b904164a69344364976159b34f2a66f3b6ad/installchocolatey.ps1."
  default = [

  ]
}


// End of CustomScript Extensions variables
// ########################################


// ######################################
// Start of DSCScript Extension variables
// for help - https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-overview
// for help - https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-template
// for help - https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-windows


variable "enableDSCScriptextension" {
  description = "Enable the DSC Script extension."
  default     = false
}


variable "DSCScriptExt_configurationUrlSasToken" {
  description = "The configuration URL sas token, from the storage account, where you are getting the DSC file from."
  default     = ""
}


variable "DSCScriptExt_Url" {
  description = "The DSC script URL of the zip file. e.g. https://f34rd364yga367.blob.core.windows.net/dsccontainer/PowershellDSC.ps1.zip."
  default     = ""
}


variable "DSCScriptExt_Name" {
  description = "The name of the script you want to run. e.g. PowerShellDSC.ps1."
  default     = ""
}


variable "DSCScriptExt_Function" {
  description = "The function you want to run e.g. PowershellDSC."
  default     = ""
}


variable "DSCScriptExt_dataCollection" {
  description = "Enables for disables elemetry collection."
  default     = "enable"
}


variable "DSCScriptExt_forcePullAndApply" {
  description = "This setting is designed to enhance the experience of working with the extension to register nodes with Azure Automation DSC."
  default     = false
}


// End of DSCScript Extensions variables
// #####################################


// #######################################
// Start of DSCService Extension variables
// for help - https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-overview
// for help - https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-template
// for help - https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-windows


variable "enableDSCServiceextension" {
  description = "Enable the DSC service extension."
  default     = false
}


variable "DSCServiceExt_RegistrationKeyPassword" {
  description = "The registration key password. This can be found using the following command: Get-AzAutomationRegistrationInfo -ResourceGroupName AzureAutomationRg -AutomationAccountName AzureAutomation."
  default     = ""
}


variable "DSCServiceExt_RegistrationUrl" {
  description = "The registration URL. This can be found using the following command: Get-AzAutomationRegistrationInfo -ResourceGroupName AzureAutomationRg -AutomationAccountName AzureAutomation."
  default     = ""
}


variable "DSCServiceExt_NodeConfigurationName" {
  description = "The node configuration name e.g. PowerShellDSC.localhost."
  default     = ""
}


variable "DSCServiceExt_ConfigurationMode" {
  description = "The configuration node can be set to one of three possibilities ApplyOnly, ApplyandMonitor, and ApplyandAutoCorrect. The default value is ApplyandMonitor."
  default     = "ApplyAndAutoCorrect"
}


variable "DSCServiceExt_ConfigurationModeFrequencyMins" {
  description = "Specifies how often LCM validates the current configuration. Default value is 15. Minimum value is 15."
  default     = 15
}


variable "DSCServiceExt_RefreshFrequencyMins" {
  description = "Specifies how often LCM attempts to check with the Automation account for updates. Default value is 30. Minimum value is 15."
  default     = 30
}


variable "DSCServiceExt_RebootNodeIfNeeded" {
  description = "Specifies whether a node can be automatically rebooted if a DSC operation requests it. Default value is false."
  default     = true
}


variable "DSCServiceExt_ActionAfterReboot" {
  description = "Specifies what happens after a reboot when applying a configuration. Valid options are ContinueConfiguration and StopConfiguration. Default value is ContinueConfiguration."
  default     = "continueConfiguration"
}


variable "DSCServiceExt_AllowModuleOverwrite" {
  description = "Specifies whether LCM overwrites existing modules on the node. Default value is false."
  default     = true
}


// End of DSCService Extensions variables
// ######################################


locals {

  lcidr = ["10.0.0.0/16"]

  counting = flatten(values(local.expanded_names))

  expanded_names = {
    for name, count in var.name_counts : name => [
      for i in range(count) : format("%s%02d", name, i)
    ]
  }

  datadisk_count_map = { for k in local.counting : k => var.disks_per_vm }

  datadisk_lun_map = flatten([
    for vm_name, count in local.datadisk_count_map : [
      for i in range(count) : {
        datadisk_name        = format("%s_datadisk%02d", vm_name, i)
        lun                  = i
        storage_account_type = "Standard_LRS"
        create_option        = "Empty"
        disk_size_gb         = var.disksize
      }
    ]
  ])

}
