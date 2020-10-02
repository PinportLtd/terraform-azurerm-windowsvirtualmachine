# My new created Terraform module

This module will create a Virtual Machine or multiple Virutal machines. You will be able to set a key vault for the username and password of the virtual machines, or if you would rather just store the password in the key vault, you can do that instead.
It will use a username and password which has been stored in a key vault. or you can specifiy them yourself. Or you can store the password only in the key vault and manually specify the admin username. You can import an existing key vault or create a new one on the fly.
It will autmatically setup the WinRM (Https) access to the Virtual Machine,
It will automatically setup the Malware extension (this is optional, but by default it will add it on.)
It will automatically setup the system managed ID to access the key vault.
It will create an extra Data Disk (you will be able to increase the amount of data disk up to 9)
It will allow you to add extensions on.??
by default the server names will be randon names, this can be overwritten and you can use whatever names you want.


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

