
// This is an advanced example, using the required variables and optional variables. This will create two virtual machines. The VM's will have one datadisk, 250GB in size. 
// The VM's will have the boot diagnostics set to a storage account. 
// WinRM will be enabled and automatically configured. This will require a certificate. The Certificate is stored in a Key Vault. This is a self-signed Certificate.
// If you are unsure how to setup a self-signed certificate in a key vault - see this link https://realworldit.net/archives/89
// The admin password is set in a key vault secret called "Default-Admin-VM-Password"
// The IaaSAntiMalware extension will be installed and setup to the default settings.
// The CustomScript extension will be installed and setup. This example will install chocolatey.
// The DSCScript extension will be setup. This will format the datadisks and create a directory on the data disk.
// You will need to create the resource group manually or use a resource group module.


module "vmwindows" {
  source = "../../"

  location          = var.location
  resourcegroupname = var.resourcegroupname
  taglist           = var.taglist

  name_counts = var.servernamesandcount

  disks_per_vm = 1
  disksize     = 250

  boot_diagnostics_storage_account_uri = {
    "uri" = "https://temp429574.blob.core.windows.net/?sv=2019-.......D"
  }

  enable_winrm = {
    "Https" = "https://kv502857.vault.azure.net/secrets/foomachines/f.......3"
  }

  secrets = {
    secrets1 = {
      store = "My"
      url   = "https://kv502857.vault.azure.net/secrets/foomachines/f.......3"
    }
  }

  // Below is specifying an existing key vault
  key_vault = {
    key_vault = {
    key_vault_resource_group  = "kv502857KeyVault"
    key_vault_name            = "kv502857"
    key_vault_secret_password = "Default-Admin-VM-Password"
    } */
  }

  // enable the IaaSAntiMalware extension.
  enableIaaSAntiMalwareExtension = true

  // enable the custom script extension and set the variables.
  enableCustomScriptextension      = true
  CustomScriptExt_commandToExecute = "powershell.exe -Command ./chocolatey.ps1; exit 0;"
  CustomScriptExt_filesUris        = "https://gist.githubusercontent.com/mcasperson/c815ac880df481418ff2e199ea1d0a46/raw/5d4fc583b28ecb27807d8ba90ec5f636387b00a3/chocolatey.ps1"

  // enable the DSCScript extension and set the variables.
  enableDSCScriptextension              = true
  DSCScriptExt_configurationUrlSasToken = "?sv=2019......D"
  DSCScriptExt_Url                      = "https://temp429574.blob.core.windows.net/dsc/PowershellDSC.ps1.zip" // you will need to build a DSC zip first. Check out 
  DSCScriptExt_Name                     = "PowershellDSC.ps1"
  DSCScriptExt_Function                 = "PowershellDSC"

}

