resource "azurerm_resource_group" "app-grp" {
    name = "app-grp"
    location = "CentralUS"
  
}

resource "azurerm_virtual_network" "app_network" {
  name = local.virtual_network.name
  location = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name
  address_space = local.virtual_network.address_prefixes
  
}

resource "azurerm_subnet" "app_network_subnets" {
  for_each = var.subnet_information
  name = each.key
  resource_group_name = azurerm_resource_group.app-grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes = [each.value.cidrblock]
}

resource "azurerm_network_interface" "network_interfaces" {
  count = var.network_interface_count
  name = "webinterface0${count.index+1}"
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.app_network_subnets["websubnet01"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webip[count.index].id
  }
  location = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name
  
}

resource "azurerm_public_ip" "webip" {
  count = var.network_interface_count
  name = "webip0${count.index+1}"
  resource_group_name = azurerm_resource_group.app-grp.name
  location = local.resource_location
  allocation_method = "Static"
}


resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name

  security_rule {
    name                       = "allowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = azurerm_subnet.app_network_subnets
  subnet_id                 = azurerm_subnet.app_network_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_windows_virtual_machine" "webvm" {
  count = var.network_interface_count
  name = "webvm0${count.index+1}"
  resource_group_name = azurerm_resource_group.app-grp.name
  location            = local.resource_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  availability_set_id = azurerm_availability_set.appset.id
  network_interface_ids = [
    azurerm_network_interface.network_interfaces[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_availability_set" "appset" {
  name                = "appset"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name
  platform_fault_domain_count = 2
  platform_update_domain_count = 2
}

