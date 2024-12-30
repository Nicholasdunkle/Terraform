locals {
  location = "East US"
}

resource "azurerm_resource_group" "IntLB-RG" {
  name = var.Resourcegroup_IntLB-RG.name
  location = local.location
  
}

resource "azurerm_virtual_network" "IntLB-Vnet" {
  name = var.Vnet_IntLB-Vnet.name
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  address_space = var.Vnet_IntLB-Vnet.address_space
  
}

resource "azurerm_subnet" "myBackendSubnet" {
  name = var.Subnet_myBackendSubnet.name
  address_prefixes = var.Subnet_myBackendSubnet.address_prefix
  virtual_network_name = var.Vnet_IntLB-Vnet.name
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  
}

resource "azurerm_network_interface" "NIC1" {
  name = "NIC1"
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.myBackendSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "TestVM" {
  admin_password = var.Virtualmachine_TestVM.admin_password
  admin_username = var.Virtualmachine_TestVM.admin_username
  name = var.Virtualmachine_TestVM.name
  size = var.Virtualmachine_TestVM.size
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  network_interface_ids = [ 
    azurerm_network_interface.NIC1.id
   ]
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
  
}

resource "azurerm_network_interface" "myVMNIC1" {
  name = "myVMNIC1"
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.myBackendSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "myVMNIC2" {
  name = "myVMNIC2"
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.myBackendSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "myVMNIC3" {
  name = "myVMNIC3"
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.myBackendSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "myVM1" {
  admin_password = var.Virtualmachine_TestVM.admin_password
  admin_username = var.Virtualmachine_TestVM.admin_username
  name = "myVM1"
  size = var.Virtualmachine_TestVM.size
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  zone = "1"
  network_interface_ids = [ 
    azurerm_network_interface.myVMNIC1.id
   ]
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
  
}

resource "azurerm_windows_virtual_machine" "myVM2" {
  admin_password = var.Virtualmachine_TestVM.admin_password
  admin_username = var.Virtualmachine_TestVM.admin_username
  name = "myVM2"
  size = var.Virtualmachine_TestVM.size
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  zone = "2"
  network_interface_ids = [ 
    azurerm_network_interface.myVMNIC2.id
   ]
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
  
}

resource "azurerm_windows_virtual_machine" "myVM3" {
  admin_password = var.Virtualmachine_TestVM.admin_password
  admin_username = var.Virtualmachine_TestVM.admin_username
  name = "myVM3"
  size = var.Virtualmachine_TestVM.size
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  zone = "3"
  network_interface_ids = [ 
    azurerm_network_interface.myVMNIC3.id
   ]
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
  
}

resource "azurerm_network_security_group" "myNSG" {
  name = "myNSG"
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  
}

resource "azurerm_public_ip" "LBPIP1" {
  name = "LBPIP1"
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "myIntLoadBalancer" {
  name = var.Loadbalancer_myIntLoadBalancer.name
  location = local.location
  resource_group_name = var.Resourcegroup_IntLB-RG.name
  sku = "Standard"
  frontend_ip_configuration {
    name = "LBPIP1"
    public_ip_address_id = azurerm_public_ip.LBPIP1.id
  }
  
}
