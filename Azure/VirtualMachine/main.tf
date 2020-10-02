module "rg" {
  source = "./modules/ResourceGroup"

  resourcegroupname = "russdeathrace"
  location = "ukwest"
  taglist = var.taglist
}


module "name2" {
  source = "./modules/VM"

taglist = var.taglist
/* name_counts = {
  "foo" = 1
} */
location = var.location
resourcegroupname = var.resourcegroupname
admin_password = var.admin_password
enableIaaSAntiMalwareExtension = true
enableCustomScriptextension = true
CustomScriptExt_commandToExecute = "powershell.exe -Command ./chocolatey.ps1; exit 0;"
CustomScriptExt_filesUris = "https://gist.githubusercontent.com/mcasperson/c815ac880df481418ff2e199ea1d0a46/raw/5d4fc583b28ecb27807d8ba90ec5f636387b00a3/chocolatey.ps1"  
}



/* module "name3" {
  source = "./modules/VM"

  taglist = var.taglist
  
name_counts = {
  "fred" = 1
}
network_subnet_Frontend_name = "Frontend2"
location = var.location
resourcegroupname = var.resourcegroupname
admin_password = var.admin_password
enableIaaSAntiMalwareExtension = true
enableCustomScriptextension = true
CustomScriptExt_commandToExecute = "powershell.exe -Command ./chocolatey.ps1; exit 0;"
CustomScriptExt_filesUris = "https://gist.githubusercontent.com/mcasperson/c815ac880df481418ff2e199ea1d0a46/raw/5d4fc583b28ecb27807d8ba90ec5f636387b00a3/chocolatey.ps1"
enableDSCScriptextension = true 
DSCScriptExt_configurationUrlSasToken = "?sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2020-10-09T17:05:02Z&st=2020-09-23T09:05:02Z&spr=https&sig=N4la%2Fn6L3zKA2wwR1jmU4BnHDO%2FQQ5yjP%2FTAeGUttJQ%3D"
DSCScriptExt_Url  = "https://terrysa.blob.core.windows.net/dsccontainer/PowershellDSC.ps1.zip"
DSCScriptExt_Name = "PowershellDSC.ps1"
DSCScriptExt_Function = "PowershellDSC"  
}
 */
/* 
module "name" {
  source = "./modules/VM"

  taglist = var.taglist

name_counts = {
  "bar" = 1
}
location = var.location
resourcegroupname = var.resourcegroupname
admin_password = var.admin_password
enableDSCServiceextension = true 
DSCServiceExt_RegistrationKeyPassword = "gRHraf2iHMYqVPC6pf78f3g7BeR0t+u+pwwLaBO4Pgjf0uzKRK1pR3gIU9m6EXGuEoN4MOKUduQ2NsLKeS376w=="
DSCServiceExt_RegistrationUrl = "https://7f4ae278-9c1e-40c7-a946-eb0fa7896a21.agentsvc.uks.azure-automation.net/accounts/7f4ae278-9c1e-40c7-a946-eb0fa7896a21"
DSCServiceExt_NodeConfigurationName = "PowerShellDSC.localhost" 
}
 */
