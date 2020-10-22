
output "vm_names" {
  description = "A list of the server names."
  value       = local.counting
}

output "resourcegroup" {
  description = "The name of the resource group"
  value       = [for rg in azurerm_windows_virtual_machine.windows : rg.resource_group_name]
}

output "datadisk_lun_map" {
  description = "A map of the datadisks and the luns number"
  value       = local.datadisk_lun_map
}

output "workingdatadisk_lun_map" {
  description = "A map for the datadisks"
  value       = [for da in local.datadisk_lun_map : da.datadisk_name]
}
output "workingdatadisk_lun_maplist" {
  description = "A map of the data disks, which the sizes and create options."
  value = { for da in local.datadisk_lun_map : da.datadisk_name => [
    "this is the disk size ${da.disk_size_gb}",
    "this is the create_option ${da.create_option}"
  ] }
}
output "datadisk_count_map" {
  description = "A map of the number of disk per vm."
  value       = local.datadisk_count_map

}

output "network_name" {
  description = "The name of the network"
  value       = azurerm_virtual_network.main.name

}

output "subnet_name" {
  description = "The subnet name."
  value       = azurerm_subnet.main.name
}

output "subnet_prefix" {
  description = "The subnet prefix."
  value       = azurerm_subnet.main.address_prefix
}

output "fqdn" {
  description = "The FQDN of each vm."
  value       = { for vm, fqdn in azurerm_public_ip.main : vm => fqdn.fqdn }
}

output "systemidentity" {
  description = "The system id of each vm."
  value       = { for name, id in azurerm_windows_virtual_machine.windows : name => id.identity.*.principal_id }
}

output "publicip" {
  description = "The public IP of each vm."
  value       = { for name, id in azurerm_windows_virtual_machine.windows : id.name => id.public_ip_address }
}

output "privateip" {
  description = "The private IP of each vm"
  value       = { for name, id in azurerm_windows_virtual_machine.windows : id.name => id.private_ip_address }
}
output "winrm_listener" {
  description = "The winrm URl of each vm."
  value       = { for name, id in azurerm_windows_virtual_machine.windows : id.name => id.winrm_listener }
}

/* output "allofvms" {
  description = "Shows all of the settings for the VM's."
  value = [azurerm_windows_virtual_machine.windows.*]
} */
/* output "allofpublicips" {
  description = "Shows all of the settings for the public ip resources."
  value = [azurerm_public_ip.main.*]
} */

