/* output "Random_Strings_for_VM_Names" {
  description = ""
  value       = random_string.rand.id
}
 */

/* output "expanded_names" {
  value = local.expanded_names
}

output "counting" {
  value = local.counting
} */


/* output "key_vault_id_russ" {
  value = data.azurerm_key_vault.keyvault[*]

}
 */


/* output "keyvault_id" {
  value = [for keyvaultresource in data.azurerm_key_vault.keyvault : keyvaultresource.id]
} */
/* 
output "datadisk_lun_map" {
  value = local.datadisk_lun_map
}

output "workingdatadisk_lun_map" {
  value = [for da in local.datadisk_lun_map : da.datadisk_name]
}
output "workingdatadisk_lun_maplist" {
  value = { for da in local.datadisk_lun_map : da.datadisk_name => [
    "this is the disk size ${da.disk_size_gb}",
    "this is the create_option ${da.create_option}"
  ] }
}
output "datadisk_count_map" {
  value = local.datadisk_count_map

} */


/* output "Frontend_Address" {
  value = values(azurerm_subnet.Frontend)

} */

/* output "Backend_Address" {
  value = values(azurerm_subnet.Backend)

} */