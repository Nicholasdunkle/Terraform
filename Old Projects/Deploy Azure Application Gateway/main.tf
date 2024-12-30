locals {
  locationEastUS = "East US"
}

resource "azurerm_resource_group" "ContosoResourceGroup" {
  name = var.ContosoResourceGroup.name
  location = local.locationEastUS
  
}

resource "azurerm_virtual_network" "ContosoVnet" {
  name = var.ContosoVnet.name
  address_space = var.ContosoVnet.address_space
  resource_group_name = var.ContosoResourceGroup.name
  location = local.locationEastUS

}

resource "azurerm_subnet" "Backend" {
  name = "BackendSubnet"
  resource_group_name = var.ContosoResourceGroup.name
  virtual_network_name = var.ContosoVnet.name
  address_prefixes = ["10.0.1.0/24"]
  depends_on = [ azurerm_virtual_network.ContosoVnet ]
  
}

resource "azurerm_subnet" "AGSubnet" {
  name = "AGSubnet"
  resource_group_name = var.ContosoResourceGroup.name
  virtual_network_name = var.ContosoVnet.name
  address_prefixes = ["10.0.0.0/24"]
  depends_on = [ azurerm_virtual_network.ContosoVnet ]
  
}

resource "azurerm_network_interface" "NIC1" {
  name = "NIC1"
  resource_group_name = var.ContosoResourceGroup.name
  location = local.locationEastUS
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.Backend.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

resource "azurerm_network_interface" "NIC2" {
  name = "NIC2"
  resource_group_name = var.ContosoResourceGroup.name
  location = local.locationEastUS
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.Backend.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

resource "azurerm_windows_virtual_machine" "BEVM1" {
  name = var.BEVM1.name
  location = local.locationEastUS
  resource_group_name = var.ContosoResourceGroup.name
  size = var.BEVM1.size
  admin_password = var.BEVM1.admin_password
  admin_username = var.BEVM1.admin_username
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  network_interface_ids = [azurerm_network_interface.NIC1.id]
  
}

resource "azurerm_windows_virtual_machine" "BEVM2" {
  name = var.BEVM2.name
  location = local.locationEastUS
  resource_group_name = var.ContosoResourceGroup.name
  size = var.BEVM1.size
  admin_password = var.BEVM1.admin_password
  admin_username = var.BEVM1.admin_username
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  network_interface_ids = [azurerm_network_interface.NIC2.id]
  
}

resource "azurerm_public_ip" "AGPublicIPAddress" {
  name = "AGPublicIPAddress"
  resource_group_name = var.ContosoResourceGroup.name
  location = local.locationEastUS
  allocation_method = "Static"
  sku = "Standard"
  
}

resource "azurerm_application_gateway" "CoreServicesVnetGateway" {
  name = var.VnetGateway_CoreServices.name
  location = local.locationEastUS
  resource_group_name = var.ContosoResourceGroup.name
  backend_address_pool {
    name = "Pool1"
  }
  backend_http_settings {
    name = "BEHTTPSettings1"
    cookie_based_affinity = "Enabled"
    port = 80
    protocol = "Http"
  }
  frontend_ip_configuration {
    name = "FrontendIP1"
    public_ip_address_id = azurerm_public_ip.AGPublicIPAddress.id
  }
  frontend_port {
    name = "FEport"
    port = 80
  }
  gateway_ip_configuration {
    name = "GatewayIPconfig"
    subnet_id = azurerm_subnet.AGSubnet.id
  }
  http_listener {
    name = "listener1"
    frontend_ip_configuration_name = "FrontendIP1"
    frontend_port_name = "FEport"
    protocol = "Http"
  }
  request_routing_rule {
    name = "rule1"
    rule_type = "Basic"
    http_listener_name = "listener1"
    backend_address_pool_name = "Pool1"
    backend_http_settings_name = "BEHTTPSettings1"
    priority = 100
  }
  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    capacity = 2
  }

  
}
