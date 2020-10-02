# terraform-azurerm-windows-virtual-machine

Deploys 1+ Virtual Machines to a defined Network

* Ability to create different named VMs and define how many of each of the named VM's 
* All VMs use Managed Disks Set how many the VMs will require. All VMs will have the same number of disk and currently all disks are set to the same size, You can define the size.
* Network Security Group (NSG) created with a single remote access rule which opens var.xxxx port
* VM nics attached to a single virtual network subnet of your choice
* Single Public IP address is assigned to each VM 
* Ability to set the administrator Username and Password to either be set locally, or use an existing Key Vault which you can define.
* Ability to Enable WinRM for each VM. This will use a HTTPS and a Certificate from an existing Key Vault (can be a self-signed certificate) 
* Ability to load certificates in to each VM.
* Ability to use Azue Spot
* Uses System Assigned as standard.

* Ability to enable four popular extensions  -  (each of the settings for all extensions have the standard defaults, but can be reconfigured if required. Each can be enabled or disabled.)
    * IaaSAntiMalware Extention - Used to enable and install IaaSAntimalware Protection on VMs.
    * Custom Script Extention - Used to run any Custom Scripts that you require.
    * DSC Script Extension - Used to run a DSC Script to configure the VMs. This cannot be used at the same time as the DSC Service.
    * DSC Service Extension - Used to connnect to a Azure Automation DSC Service. This cannot be used at the same time as the DSC Script.

* Ability to change the following:-




I've tried to make this as useable to difference various of a virtual machine.

Whats Dynamic
The creation of the following blocks in the the Virtual Machine resouce:-
Secret Block - If you don't specify anything it will still run
Winrm_listener block - If you don't required to use WinRM then leave it empty.
Boot_diagnostics block - If you don't require Boot Diags then leave it empty.



Required Minimum Variables
Resource Group Name
Location



Changable variables
* Tags
* Existing Key Vault Name
* Existing Key Vault Resource Group
* Existing Key Vault Secret Name for Admin Username (Although this is still showed in the Plan and Apply. I've found people like to store both the Username and Password in a Key Vault together. This doesn't have to be the case it is interchangeable.)
* Existing Key Vault Secret Name for Admin Password.

* Network Subnet Name

* The Name of the Virtual Machines, this is a map, and can have more than one VM name, along with the number of machine to be created with that name. It will have an an index added to the end of the name.
* The Admin Username, if you don't want to use an existing Key Vault to store the Username.
* The Admin Password, If you don't want to use an existing Key Vault to store the Password.
* evition_policy - if you are using Azure Spot - Currently you can only set it to deallocate.
* priority - Allows you to set the variable to use Azure Spot or not.
* VMsize - Allows you to set the VMsize.
* timezone - Allows you to set the timezone of the VMs
* Allows you to set the identity type to either SystemAssigned or not.
* Allows you to change the Caching of the OS Disk
* Allows you to change the storage_account_type of the OS Disk
* Allows you to add certificates to each VM
* Allows you to select different version of windows operating systems.
* Allows you to enable WinRm for the machines
* Allows you to set the boot diagsnostics

* Allows you to set the number of Data Disk for the VMs
* Allows you to set the size of the Data Disk for the VMs
* Allows you to Enable or Disable all extensions
* Allows you to configure each option for each extension








## Usage

Provide the sample code to use your module.

## Scenarios

If you would like to 

## Examples

Paste the links to your sample code in `examples` folder.

## Inputs

List all input variables of your module.

location (default of "uksouth")

resourcegroupname (default of "Pinport")

Vm_names (default of "data1")

admin_username (pinport)
 
admin_password (pinport)

use_existing_keyvault (default of false) If you are using an existing key vault you will need to set this to true

Then set the following variables -

rg_keyvault - the resource group name where the existing key vault exists
keyvault_name - the name of the key vault
keyvault_secret_username - the secret name of the username
keyvault_secret_password - the secret name of the password

If you only want to store the password then set the following variable

secret_password_ony - to true

This will allow you to specifiy the admin username in the variable file.






## Outputs

List all output variables of your module.

