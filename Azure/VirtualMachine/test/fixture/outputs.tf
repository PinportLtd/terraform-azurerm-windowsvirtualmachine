
output "vm_names" {
  description = "The name of the vm's."
  value       = module.vmwindows.vm_names
}

output "resourcegroup" {
  description = "The name of the resource group."
  value       = module.vmwindows.resourcegroup
}


output "datadisk_count_map" {
  description = "A map of the number of disk per vm."
  value       = module.vmwindows.datadisk_count_map
}

output "network_name" {
  description = "The name of the network"
  value       = module.vmwindows.network_name

}

output "subnet_name" {
  description = "The subnet name."
  value       = module.vmwindows.subnet_name
}

output "subnet_prefix" {
  description = "The subnet prefix."
  value       = module.vmwindows.subnet_prefix
}

output "fqdn" {
  description = "The FQDN of each vm."
  value       = module.vmwindows.fqdn
}

output "systemidentity" {
  description = "The system id of each vm."
  value       = module.vmwindows.systemidentity
}

output "publicip" {
  description = "The public IP of each vm."
  value       = module.vmwindows.publicip
}

output "privateip" {
  description = "The private IP of each vm"
  value       = module.vmwindows.privateip
}


/* output "allofvms" {
  description = "Shows all of the settings for the VM's."
  value = module.vmwindows.allofvms
} */

/* output "allofpublicips" {
  description = "Shows all of the settings for the public ip resources."
  value = module.vmwindows.allofpublicips
}  */