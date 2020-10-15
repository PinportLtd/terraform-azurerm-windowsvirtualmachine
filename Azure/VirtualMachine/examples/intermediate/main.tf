
// This is an intermediate example, using the required variables and optional variables. This will create two virtual machines. The VM's will have one datadisk, 32GB in size (default). 
// The VM's will have the boot diagnostics set to a storage account. 
// WinRM will be enabled and automatically configured. This will require a certificate. The Certificate is stored in a Key Vault. This is a self-signed Certificate.
// If you are unsure how to setup a self-signed certificate in a key vault - see this link https://realworldit.net/archives/89
// The admin password is set in a key vault secret called "Default-Admin-VM-Password"
// The IaaSMalware extension will be installed and setup to the default settings.
// You will need to create the resource group manually or use a resource group module.


module "vmwindows" {
  source = "../../"

  location          = var.location
  resourcegroupname = var.resourcegroupname
  taglist           = var.taglist

  name_counts = {
    "foo" = 2
  }
  disks_per_vm = 1

  # TODO You'll need to set the boot diags to a storage account you own and get the Access Token for it.

  /* boot_diagnostics_storage_account_uri = {
    "uri" = "https://temp429574.blob.core.windows.net/?sv=2019-......D"
  }
 */
  # TODO You'll need to set enable_winrm to an existing keyvault. Create a self-signed certificate and copy the secrets token.
  # Note: This is the same URL as in the secrets. That is how it's supposed to be.
  # If you are stuck see this article - https://realworldit.net/archives/89

  /* enable_winrm = {
    "Https" = "https://kv502857.vault.azure.net/secrets/foomachines/f......3"
  }
 */
  # TODO You'll need to set the secrets to an existing keyvault. Create a self-signed certificate and copy the secrets token
  # if you are stuck see this article - https://realworldit.net/archives/89

  /* secrets = {

    secrets1 = {
      store = "My"
      url   = "https://kv502857.vault.azure.net/secrets/foomachines/f......3"
    }
  } */

  // Below is specifying an existing key vault
  /* key_vault = {
    key_vault = {
      key_vault_resource_group  = "kv502857KeyVault"
      key_vault_name            = "kv502857"
      key_vault_secret_password = "Default-Admin-VM-Password" // This is the name of the secret in the key vault.
    }
  }
 */
  enableIaaSAntiMalwareExtension = true

}



