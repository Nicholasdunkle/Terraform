resource "azurerm_resource_group" "app-grp" {
  name = "app-grp"
  location = local.resource_location
}
