# terraform-azurerm-windowsvirtualmachine Module

* This module will create a virtual machine or multiple virutal machines.
* You can set the name of the machines, and specify how many of them you want starting with each name. Check out the examples
* You will be able to use an existing key vault for the Administrator password or you can set it as a variable.
* It will setup the WinRM (Https) access to the virtual machine/s
* It has the ability to add mutliple certificates to the virutal machine/s.
* It has the ability to add Data Disk, all disks are set to the same size, that you specifiy
* It has the ability to add extensions on to the virtual machines. There are four extensions. IaaSAntiMalware, Custom Script, DSC Script, DSC Service. (DSC Script and DSC Service cannot be used together, it's one or the other.)
* Each VM gets a public IP address (Changing in V2)

## Usage

``` hcl
module "vmwindows" {
  source            = "../../"
  location          = var.location
  resourcegroupname = var.resourcegroupname
  admin_password    = var.admin_password
}
```

## Scenarios

In the examples folder below I have created different scenarios, a simple, Intermediate and an Advanced example using the module.

## Examples

https://github.com/PinportLtd/terraform-azurerm-windowsvirtualmachine/tree/master/examples

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| CustomScriptExt\_commandToExecute | The command to run e.g. powershell.exe -Command ./chocolatey.ps1; exit 0; . | `string` | `""` | no |
| CustomScriptExt\_filesUris | The location URL of the script to run e.g. https://gist.githubusercontent.com/Russtym/29dd88d6b14af89a715646c73bd03c38/raw/61e9b904164a69344364976159b34f2a66f3b6ad/installchocolatey.ps1. | `list` | `[]` | no |
| DSCScriptExt\_Function | The function you want to run e.g. PowershellDSC. | `string` | `""` | no |
| DSCScriptExt\_Name | The name of the script you want to run. e.g. PowerShellDSC.ps1. | `string` | `""` | no |
| DSCScriptExt\_Url | The DSC script URL of the zip file. e.g. https://f34rd364yga367.blob.core.windows.net/dsccontainer/PowershellDSC.ps1.zip. | `string` | `""` | no |
| DSCScriptExt\_configurationUrlSasToken | The configuration URL sas token, from the storage account, where you are getting the DSC file from. | `string` | `""` | no |
| DSCScriptExt\_dataCollection | Enables for disables elemetry collection. | `string` | `"enable"` | no |
| DSCScriptExt\_forcePullAndApply | This setting is designed to enhance the experience of working with the extension to register nodes with Azure Automation DSC. | `bool` | `false` | no |
| DSCServiceExt\_ActionAfterReboot | Specifies what happens after a reboot when applying a configuration. Valid options are ContinueConfiguration and StopConfiguration. Default value is ContinueConfiguration. | `string` | `"continueConfiguration"` | no |
| DSCServiceExt\_AllowModuleOverwrite | Specifies whether LCM overwrites existing modules on the node. Default value is false. | `bool` | `true` | no |
| DSCServiceExt\_ConfigurationMode | The configuration node can be set to one of three possibilities ApplyOnly, ApplyandMonitor, and ApplyandAutoCorrect. The default value is ApplyandMonitor. | `string` | `"ApplyAndAutoCorrect"` | no |
| DSCServiceExt\_ConfigurationModeFrequencyMins | Specifies how often LCM validates the current configuration. Default value is 15. Minimum value is 15. | `number` | `15` | no |
| DSCServiceExt\_NodeConfigurationName | The node configuration name e.g. PowerShellDSC.localhost. | `string` | `""` | no |
| DSCServiceExt\_RebootNodeIfNeeded | Specifies whether a node can be automatically rebooted if a DSC operation requests it. Default value is false. | `bool` | `true` | no |
| DSCServiceExt\_RefreshFrequencyMins | Specifies how often LCM attempts to check with the Automation account for updates. Default value is 30. Minimum value is 15. | `number` | `30` | no |
| DSCServiceExt\_RegistrationKeyPassword | The registration key password. This can be found using the following command: Get-AzAutomationRegistrationInfo -ResourceGroupName AzureAutomationRg -AutomationAccountName AzureAutomation. | `string` | `""` | no |
| DSCServiceExt\_RegistrationUrl | The registration URL. This can be found using the following command: Get-AzAutomationRegistrationInfo -ResourceGroupName AzureAutomationRg -AutomationAccountName AzureAutomation. | `string` | `""` | no |
| IaaSAntimalwareExt\_AntimalwareEnabled | Enables the antimalware in the extension. | `string` | `"true"` | no |
| IaaSAntimalwareExt\_Exclusions\_Extensions | List of file extensions to exclude. | `string` | `""` | no |
| IaaSAntimalwareExt\_Exclusions\_Paths | List of files or paths to exclude. | `string` | `""` | no |
| IaaSAntimalwareExt\_Exclusions\_Processes | List of process to exclude. | `string` | `""` | no |
| IaaSAntimalwareExt\_RealtimeProtectionEnabled | Enables the antimalware realtime protection. | `string` | `"true"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_day | Set the Day settings. | `string` | `"1"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_isEnabled | Enables the scheduled scan. | `string` | `"true"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_scanType | Which Scan Type to run. | `string` | `"Quick"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_time | Set the Scan time. | `string` | `"120"` | no |
| admin\_password | This is the Administrator's Password. Use If you are not storing the password in a key vault. | `string` | `"PassWORD@123!DoNOTuseTHIS!AlthoughItIsSoLongMayBE1tWillBeOK!"` | no |
| admin\_username | The name of the Administrator. | `string` | `"azureadmin"` | no |
| boot\_diagnostics\_storage\_account\_uri | The URI of the storage account where you are storing the boot diags. - see examples for help. | `map` | `{}` | no |
| caching | The caching of the OS Disk. | `string` | `"ReadWrite"` | no |
| disks\_per\_vm | Number of disk per VM. | `number` | `0` | no |
| disksize | The size of the disk in GB. This will apply to all Data Disks. | `number` | `32` | no |
| enableCustomScriptextension | Enable the Custom Script extension. | `bool` | `false` | no |
| enableDSCScriptextension | Enable the DSC Script extension. | `bool` | `false` | no |
| enableDSCServiceextension | Enable the DSC service extension. | `bool` | `false` | no |
| enableIaaSAntiMalwareExtension | Enables the IaaSAntiMalware extension. | `bool` | `false` | no |
| enable\_automatic\_updates | Enables auto updates on the VM/s. | `bool` | `true` | no |
| enable\_winrm | Enables WinRM - see examples for help. | `map` | `{}` | no |
| eviction\_policy | Sets the eviction policy if the VM is set to use azure Spot. The only available option is to deallocate at the moment. | `string` | `"Deallocate"` | no |
| identity\_type | The identity type can be set to systemassigned or userassigned. | `string` | `"SystemAssigned"` | no |
| imageoffer | The offer of the image e.g. WindowsServer. | `string` | `"WindowsServer"` | no |
| imagepublishername | The publishers name of the image e.g. MicrosoftWindowsServer. | `string` | `"MicrosoftWindowsServer"` | no |
| imagesku | The SKU of the image e.g. 2019-DataCenter. | `string` | `"2019-DataCenter"` | no |
| imageskuversion | The version of the SKU of the image e.g. latest. | `string` | `"latest"` | no |
| key\_vault | Existing Key Vault Settings. | <pre>map(object({<br>    key_vault_resource_group  = string<br>    key_vault_name            = string<br>    key_vault_secret_password = string<br>  }))</pre> | `{}` | no |
| location | The Azure location of the Resource Group. | `any` | n/a | yes |
| name\_counts | The name and number of machines. | `map(number)` | <pre>{<br>  "foo": 1<br>}</pre> | no |
| network\_subnet\_name | The name of the subnet. | `string` | `"Frontend"` | no |
| priority | Set to either Regular or Spot. To use azure spot set to Spot. | `string` | `"Regular"` | no |
| resourcegroupname | The Resource Group Name. | `any` | n/a | yes |
| secrets | Secrets are the certificates - see examples for help. | <pre>map(object({<br>    store = string<br>    url   = string<br>  }))</pre> | `{}` | no |
| storage\_account\_type | The storage account type can be one of three options. | `string` | `"Standard_LRS"` | no |
| taglist | This is the tags for the project. | `map(string)` | `{}` | no |
| timezone | The timezone for the VM/s. | `string` | `"GMT Standard Time"` | no |
| vmsize | The size of the VM/s. | `string` | `"Standard_B2ms"` | no |

## Outputs

| Name | Description |
|------|-------------|
| datadisk\_count\_map | A map of the number of disk per vm. |
| datadisk\_lun\_map | A map of the datadisks and the corresponding luns number. |
| fqdn | The FQDN of each vm. |
| network\_name | The name of the network. |
| privateip | The private IP of each vm. |
| publicip | The public IP of each vm. |
| resourcegroup | The name of the resource Group. |
| subnet\_name | The subnet name. |
| subnet\_prefix | The subnet prefix. |
| systemidentity | The system id of each vm. |
| vm\_names | A list of the server names. |
| winrm\_listener | The winrm URl of each vm. |
| workingdatadisk\_lun\_map | A map for the datadisks. |
| workingdatadisk\_lun\_maplist | A map of the datadisks, the sizes and create options. |

