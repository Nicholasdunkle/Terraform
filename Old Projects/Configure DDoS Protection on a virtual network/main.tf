locals {
  location = "East US"
}

resource "azurerm_resource_group" "MyResourceGroup" {
  name = var.resourcegroup_MyRG.name
  location = local.location
  
}

resource "azurerm_virtual_network" "MyVirtualNetwork" {
  name = "MyVirtualNetwork"
  location = local.location
  resource_group_name = var.resourcegroup_MyRG.name
  address_space = [ "10.0.0.0/16" ]
  depends_on = [ azurerm_resource_group.MyResourceGroup ]
}

resource "azurerm_subnet" "AGSubnet" {
  virtual_network_name = azurerm_virtual_network.MyVirtualNetwork.name
  resource_group_name = var.resourcegroup_MyRG.name
  address_prefixes = [ "10.0.0.0/24" ]
  name = "AGSubnet"
  depends_on = [ azurerm_virtual_network.MyVirtualNetwork ]
  
}

resource "azurerm_public_ip" "PIP1" {
  location = local.location
  resource_group_name = var.resourcegroup_MyRG.name
  name = "PIP1"
  allocation_method = "Static"
  depends_on = [ azurerm_resource_group.MyResourceGroup ]
}

resource "azurerm_network_interface" "NIC1" {
  name = "NIC1"
  location = local.location
  resource_group_name = var.resourcegroup_MyRG.name
  ip_configuration {
    name = "IPconfig1"
    subnet_id = azurerm_subnet.AGSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PIP1.id
  }
  depends_on = [ azurerm_public_ip.PIP1 ]
}

resource "azurerm_windows_virtual_machine" "MyVirtualMachine" {
  name = "MyVirtualMachin"
  admin_password = "Password123!"
  admin_username = "nsdunkle"
  location = local.location
  resource_group_name = var.resourcegroup_MyRG.name
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  size = "Standard_B2s"
  network_interface_ids = [azurerm_network_interface.NIC1.id]
  depends_on = [ azurerm_network_interface.NIC1 ]
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }
}

resource "azurerm_network_ddos_protection_plan" "MyDdosProtectionPlan" {
  resource_group_name = var.resourcegroup_MyRG.name
  location = local.location
  name = "MyDdosProtectionPlan"
}

