resource "azurerm_resource_group" "Contoso" {
  name     = var.resourcegroup_Contoso["name"]
  location = var.resourcegroup_Contoso["location"]
}

resource "azurerm_virtual_network" "Contoso" {
  name = var.Vnet_ContosoVnet.name
  location = var.Vnet_ContosoVnet.location
  resource_group_name = var.resourcegroup_Contoso.name
  address_space = var.Vnet_ContosoVnet.address_space
 
}

resource "azurerm_virtual_network" "Research" {
  name = var.Vnet_Research.name
  location = var.Vnet_Research.location
  resource_group_name = var.resourcegroup_Contoso.name
  address_space = var.Vnet_Research.address_space
  
}

resource "azurerm_subnet" "Researchsubnet" {
  name = var.Researchsubnet.name
  resource_group_name = var.resourcegroup_Contoso.name
  virtual_network_name = var.Vnet_Research.name
  address_prefixes = var.Researchsubnet.address_prefix
  
}

resource "azurerm_virtual_wan" "ContosoVirtualWAN" {
  name                = var.VirtualWAN_Contoso.name
  resource_group_name = var.resourcegroup_Contoso.name
  location            = var.VirtualWAN_Contoso.location
}

resource "azurerm_virtual_hub" "example" {
  name                = "Contoso_VWAN_Hub"
  resource_group_name = var.resourcegroup_Contoso.name
  location            = var.VirtualWAN_Contoso.location
  virtual_wan_id      = azurerm_virtual_wan.ContosoVirtualWAN.id
  address_prefix      = "10.60.0.0/24"
}
