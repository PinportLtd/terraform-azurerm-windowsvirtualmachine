# terraform-azurerm-windowsvirtualmachine Module

* This module will create a virtual machine or multiple virutal machines.
* You can set the name of the machines, and specify how many of them you want starting with each name. Check out the examples
* You will be able to use an existing key vault for the Administrator password or you can set it as a variable.
* It will setup the WinRM (Https) access to the virtual machine/s
* It has the ability to add mutliple certificates to the virutal machine/s.
* It has the ability to add Data Disk, all disks are set to the same size, that you specifiy
* It has the ability to add extensions on to the virtual machines. There are four extensions. IaaSAntiMalware, Custom Script, DSC Script, DSC Service. (DSC Script and DSC Service cannot be used together, it's one or the other.)

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
| CustomScriptExt\_commandToExecute | The Command to run e.g. powershell.exe -Command ./chocolatey.ps1; exit 0; . | `string` | `""` | no |
| CustomScriptExt\_filesUris | The location URL of the script to run e.g. https://gist.githubusercontent.com/Russtym/29dd88d6b14af89a715646c73bd03c38/raw/61e9b904164a69344364976159b34f2a66f3b6ad/installchocolatey.ps1 | `list` | `[]` | no |
| DSCScriptExt\_Function | The Function you want to run e.g. PowershellDSC | `string` | `""` | no |
| DSCScriptExt\_Name | The Name of the Script you want to run. e.g. PowerShellDSC.ps1 | `string` | `""` | no |
| DSCScriptExt\_Url | The DSC Script URL of the zip file. e.g. https://f34rd364yga367.blob.core.windows.net/dsccontainer/PowershellDSC.ps1.zip | `string` | `""` | no |
| DSCScriptExt\_configurationUrlSasToken | The Configuration URL Sas Token, from the Storage account | `string` | `""` | no |
| DSCScriptExt\_dataCollection | Description | `string` | `"enable"` | no |
| DSCScriptExt\_forcePullAndApply | Description | `bool` | `false` | no |
| DSCServiceExt\_ActionAfterReboot | Description | `string` | `"continueConfiguration"` | no |
| DSCServiceExt\_AllowModuleOverwrite | Description | `bool` | `true` | no |
| DSCServiceExt\_ConfigurationMode | The Configuration Mode can be set to one of three possibilities ApplyAndAutoCorrect, . | `string` | `"ApplyAndAutoCorrect"` | no |
| DSCServiceExt\_ConfigurationModeFrequencyMins | n/a | `number` | `15` | no |
| DSCServiceExt\_NodeConfigurationName | The Node Configuration Name e.g. PowerShellDSC.localhost | `string` | `""` | no |
| DSCServiceExt\_RebootNodeIfNeeded | Description | `bool` | `true` | no |
| DSCServiceExt\_RefreshFrequencyMins | Description | `number` | `30` | no |
| DSCServiceExt\_RegistrationKeyPassword | The Registration Key Password. This can be found using the following command: | `string` | `""` | no |
| DSCServiceExt\_RegistrationUrl | The Registration URL. This can be found using the following command. | `string` | `""` | no |
| IaaSAntimalwareExt\_AntimalwareEnabled | Enable the Antimalware | `string` | `"true"` | no |
| IaaSAntimalwareExt\_Exclusions\_Extensions | Description | `string` | `""` | no |
| IaaSAntimalwareExt\_Exclusions\_Paths | Description | `string` | `""` | no |
| IaaSAntimalwareExt\_Exclusions\_Processes | Description | `string` | `""` | no |
| IaaSAntimalwareExt\_RealtimeProtectionEnabled | Enable the Antimalware Realtime Protection | `string` | `"true"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_day | Set the Day settings | `string` | `"1"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_isEnabled | Enable the Scheduled Scan | `string` | `"true"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_scanType | The the Scan Type | `string` | `"Quick"` | no |
| IaaSAntimalwareExt\_ScheduledScanSettings\_time | Set the Scan time | `string` | `"120"` | no |
| admin\_password | This is the Administrator's Password. Use If you are not storing the password in a key vault. | `string` | `"PassWORD@123"` | no |
| admin\_username | The name of the administrator | `string` | `"azureadmin"` | no |
| boot\_diagnostics\_storage\_account\_uri | Description | `map` | `{}` | no |
| caching | The caching of the OS Disk | `string` | `"ReadWrite"` | no |
| disks\_per\_vm | Number of disk per VM | `number` | `0` | no |
| disksize | The size of the disk in GB. This will apply to all Data Disks | `number` | `32` | no |
| enableCustomScriptextension | Enable the Custom Script Extension | `bool` | `false` | no |
| enableDSCScriptextension | Enable the DSC Script Extension | `bool` | `false` | no |
| enableDSCServiceextension | Enable the DSC Service Extension. | `bool` | `false` | no |
| enableIaaSAntiMalwareExtension | Enable the IaaSAntiMalware Extension | `bool` | `false` | no |
| enable\_automatic\_updates | Enables auto updates on the VM | `bool` | `true` | no |
| enable\_winrm | Enables WinRM | `map` | `{}` | no |
| eviction\_policy | Sets the evition policy if the VM is set to use azure Spot. The only available option is to deallocate at the moment | `string` | `"Deallocate"` | no |
| identity\_type | The identity type can be set to systemassigned or userassigned | `string` | `"SystemAssigned"` | no |
| imageoffer | The Office of the Image e.g. WindowsServer | `string` | `"WindowsServer"` | no |
| imagepublishername | The Publishers name of the image e.g. MicrosoftWindowsServer | `string` | `"MicrosoftWindowsServer"` | no |
| imagesku | The SKU of the Image e.g. 2019-DataCenter | `string` | `"2019-DataCenter"` | no |
| imageskuversion | The version of the SKU of the Image e.g. latest | `string` | `"latest"` | no |
| key\_vault | Existing Key Vault Settings | <pre>map(object({<br>    key_vault_resource_group  = string<br>    key_vault_name            = string<br>    key_vault_secret_password = string<br>  }))</pre> | `{}` | no |
| location | The Azure location of the virtual machine | `any` | n/a | yes |
| name\_counts | The name and number of machines | `map(number)` | <pre>{<br>  "foo": 1<br>}</pre> | no |
| network\_subnet\_name | Description | `string` | `"Frontend"` | no |
| priority | Set to either Regulare or Spot. To use azure spot set to Spot | `string` | `"Regular"` | no |
| resourcegroupname | The Resource Group Name | `any` | n/a | yes |
| secrets | The Secrets | <pre>map(object({<br>    store = string<br>    url   = string<br>  }))</pre> | `{}` | no |
| storage\_account\_type | The Storage Account type can be one of three options | `string` | `"Standard_LRS"` | no |
| taglist | This is the tags for the Virtual Machine. | `map(string)` | `{}` | no |
| timezone | The timezone for the VMs | `string` | `"GMT Standard Time"` | no |
| vmsize | The size of the VM | `string` | `"Standard_B2ms"` | no |

## Outputs

| Name | Description |
|------|-------------|
| datadisk\_count\_map | A map of the number of disk per vm. |
| datadisk\_lun\_map | A map of the datadisks and the luns number |
| fqdn | The FQDN of each vm. |
| network\_name | The name of the network |
| privateip | The private IP of each vm |
| publicip | The public IP of each vm. |
| resourcegroup | The name of the resource group |
| subnet\_name | The subnet name. |
| subnet\_prefix | The subnet prefix. |
| systemidentity | The system id of each vm. |
| vm\_names | A list of the server names. |
| winrm\_listener | The winrm URl of each vm. |
| workingdatadisk\_lun\_map | A map for the datadisks |
| workingdatadisk\_lun\_maplist | A map of the data disks, which the sizes and create options. |

