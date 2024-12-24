 resource "azurerm_resource_group" "Contoso" {
  name     = "ContosoResourceGroup"
  location = "East US"
}


resource "azurerm_virtual_network" "CoreServices" {
  name                = "CoreServicesVnet"
  location            = "East US"
  resource_group_name = azurerm_resource_group.Contoso.name
  address_space       = ["10.20.0.0/16"]

  subnet {
    name           = "CoreServicesSubnet"
    address_prefix = "10.20.0.0/24"
  }

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.20.1.0/27"
  }
}

// TestVM1 in CoreServicesSubnet

data "azurerm_subnet" "core_services_subnet" {
  name                 = "CoreServicesSubnet"
  virtual_network_name = azurerm_virtual_network.CoreServices.name
  resource_group_name  = azurerm_resource_group.Contoso.name
}


resource "azurerm_virtual_network" "Manufacturing" {
  name                = "ManufacturingVnet"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.Contoso.name
  address_space       = ["10.30.0.0/16"]

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "10.30.1.0/27"
  }

  subnet {
    name           = "ManufacturingSystemsSubnet"
    address_prefix = "10.30.10.0/24"
  }
}


resource "azurerm_network_interface" "nic1" {
  location = "East US"
  name = "nic1"
  resource_group_name = azurerm_resource_group.Contoso.name
  ip_configuration {
    name = "ipconfig1"
    subnet_id = data.azurerm_subnet.core_services_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.20.0.4"
  }
}

resource "azurerm_windows_virtual_machine" "TestVM1" {
  name = "TestVM1"
  admin_password = "enterpasswordhere"
  admin_username = "adminuser"
  location = "East US"
  network_interface_ids = [azurerm_network_interface.nic1.id]
  resource_group_name = "ContosoResourceGroup"
  size = "Standard_B2s"
  os_disk {
    caching = "None"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"
  }


}

// Manufacturing VM ///////////////////////////////////////////////


data "azurerm_subnet" "Manufacturing_subnet" {
  name                 = "Manufacturingsystemssubnet"
  virtual_network_name = azurerm_virtual_network.Manufacturing.name
  resource_group_name  = azurerm_resource_group.Contoso.name
}

resource "azurerm_network_interface" "Manufacturing" {
  location = "West Europe"
  name = "nic2"
  resource_group_name = azurerm_resource_group.Contoso.name
  ip_configuration {
    name = "ipconfig1"
    subnet_id = data.azurerm_subnet.Manufacturing_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.30.10.4"
  }
}

resource "azurerm_windows_virtual_machine" "ManufacturingVM" {
  name = "ManufacturingVM"
  admin_password = "enterpasswordhere"
  admin_username = "adminuser"
  location = "West Europe"
  network_interface_ids = [azurerm_network_interface.Manufacturing.id]
  resource_group_name = "ContosoResourceGroup"
  size = "Standard_B2s"
  os_disk {
    caching = "None"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"
  }


}


// Virtual Network Gateway: CoreServicesVnet

data "azurerm_subnet" "Gateway_CoreServices" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.CoreServices.name
  resource_group_name  = azurerm_resource_group.Contoso.name
}

resource "azurerm_public_ip" "CSGateway" {
  name = "PIPCoreServicesGateway"
  resource_group_name = azurerm_resource_group.Contoso.name
  location = azurerm_virtual_network.CoreServices.location
  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "example" {
  location = azurerm_virtual_network.CoreServices.location
  name = "CoreServicesVnetGateway"
  resource_group_name = azurerm_resource_group.Contoso.name
  sku = "VpnGw1"
  type = "Vpn"
  ip_configuration {
    subnet_id = data.azurerm_subnet.Gateway_CoreServices.id
    public_ip_address_id = azurerm_public_ip.CSGateway.id
  }
}


// Virtual Network Gateway: ManufacturingVnetGateway ////////////////////////////////////

data "azurerm_subnet" "Gateway_Manufacturing" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.Manufacturing.name
  resource_group_name  = azurerm_resource_group.Contoso.name
}

resource "azurerm_public_ip" "MFGateway" {
  name = "PIPManufacturingGateway"
  resource_group_name = azurerm_resource_group.Contoso.name
  location = azurerm_virtual_network.Manufacturing.location
  sku = "Standard"
  allocation_method = "Static"

}

resource "azurerm_virtual_network_gateway" "Manufacturing" {
  location = azurerm_virtual_network.Manufacturing.location
  name = "ManufacturingVnetGateway"
  resource_group_name = azurerm_resource_group.Contoso.name
  sku = "VpnGw1"
  type = "Vpn"
  ip_configuration {
    subnet_id = data.azurerm_subnet.Gateway_Manufacturing.id
    public_ip_address_id = azurerm_public_ip.MFGateway.id
  }
}
