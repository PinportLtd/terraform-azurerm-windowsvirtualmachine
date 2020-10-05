
resource "azurerm_resource_group" "main" {
  name     = var.resourcegroupname
  location = var.location
  tags     = var.taglist
}