resource "azurerm_virtual_network" "app-network" {
    name = var.app_environment.production.virtualnetworkname
    location = local.resource_location
    address_space = [var.app_environment.production.virtualnetworkcidrblock]
    resource_group_name = azurerm_resource_group.app-grp.name
  
}

resource "azurerm_subnet" "app-network-subnets" {
    for_each = var.app_environment.production.subnets
    name = each.key
    virtual_network_name = azurerm_virtual_network.app-network.name
    resource_group_name = azurerm_resource_group.app-grp.name
    address_prefixes = [each.value.cidrblock]
  
}

resource "azurerm_network_security_group" "app-nsg" {
    name = "app-nsg"
    location = local.resource_location
    resource_group_name = azurerm_resource_group.app-grp.name

    dynamic security_rule {
        for_each = local.networksecuritygrouprules
      content {
        name = "Allow-${security_rule.value.destination_port_range}"
        priority = security_rule.value.priority
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = security_rule.value.destination_port_range
        source_address_prefix = "*"
        destination_address_prefix = "*"
      }
    }
  
}

resource "azurerm_subnet_network_security_group_association" "subnet_appnsg" {
    network_security_group_id = azurerm_network_security_group.app-nsg.id
    subnet_id = azurerm_subnet.app-network-subnets["dbsubnet"].id
  
}
