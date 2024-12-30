resource "azurerm_resource_group" "app-grp" {
    name = "app-grp"
    location = "CentralUS"
  
}

resource "azurerm_virtual_network" "app_network" {
  name                = local.virtual_network.name
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name
  address_space       = local.virtual_network.address_prefixes

}

resource "azurerm_subnet" "websubnet01" {
  name                 = local.subnets.names[0]
  resource_group_name  = azurerm_resource_group.app-grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = [local.subnets.address_prefixes[0]]

}

resource "azurerm_subnet" "appsubnet01" {
  name                 = local.subnets.names[1]
  resource_group_name  = azurerm_resource_group.app-grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = [local.subnets.address_prefixes[1]]

}

resource "azurerm_network_interface" "webinterface01" {
  name                = "webinterface01"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webip01.id
  }
}


resource "azurerm_public_ip" "webip01" {
  name                = "webip01"
  resource_group_name = azurerm_resource_group.app-grp.name
  location            = local.resource_location
  allocation_method   = "Static"

}

resource "azurerm_network_security_group" "app-nsg" {
  name                = "app-nsg"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.app-grp.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "3389"
    source_address_prefix      = "*" # Dont do this, just an example
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "websubnet01" {
  subnet_id                 = azurerm_subnet.websubnet01.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "appsubnet01" {
  subnet_id                 = azurerm_subnet.appsubnet01.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}

resource "azurerm_windows_virtual_machine" "webvm01" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.app-grp.name
  location            = local.resource_location
  size                = "Standard_B1ls"
  admin_username      = var.admin_username
  admin_password      = var.admin_password 
  network_interface_ids = [
    azurerm_network_interface.webinterface01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "datadisk01" {
  name                 = "datadisk01"
  location             = local.resource_location
  resource_group_name  = azurerm_resource_group.app-grp.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"

}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk01_webvm01" {
  managed_disk_id    = azurerm_managed_disk.datadisk01.id
  virtual_machine_id = azurerm_windows_virtual_machine.webvm01.id
  lun                = "10"
  caching            = "ReadWrite"
}
