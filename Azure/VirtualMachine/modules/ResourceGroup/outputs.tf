output "resourcegroupname" {
  value = azurerm_resource_group.main.name
}

output "Location" {
  value = azurerm_resource_group.main.location
}

output "ResourceGroupId" {
  value = azurerm_resource_group.main.id
}
