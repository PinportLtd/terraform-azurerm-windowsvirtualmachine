// This is a simple example, using the required variables only. No extensions, datadisks, will be added. Just one vitual machine will be created called foo00. 
// You will need to create the resource group manually, or use a resource group module.



module "vmwindows" {
  source            = "../../"
  location          = var.location
  resourcegroupname = var.resourcegroupname
  admin_password    = var.admin_password
}

