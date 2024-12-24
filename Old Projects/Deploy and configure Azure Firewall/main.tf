locals {
  location = "CentralUS"
}

resource "azurerm_resource_group" "Test-FW-RG" {
  name = var.Test-FW-RG.name
  location = local.location
  
}

resource "azurerm_virtual_network" "Test-FW-VN" {
  name = var.Test-FW-VN.name
  location = local.location
  address_space = var.Test-FW-VN.address_space
  resource_group_name = var.Test-FW-RG.name
  depends_on = [ azurerm_resource_group.Test-FW-RG ]
  
}

resource "azurerm_subnet" "Workload-SN" {
  name = var.Workload-SN.name
  resource_group_name = var.Test-FW-RG.name
  virtual_network_name = var.Test-FW-VN.name
  address_prefixes = [ "10.0.2.0/24" ]
  depends_on = [ azurerm_virtual_network.Test-FW-VN ]
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name = var.AzureFirewallSubnet.name
  resource_group_name = var.Test-FW-RG.name
  virtual_network_name = var.Test-FW-VN.name
  address_prefixes = [ "10.0.0.0/26" ]
  depends_on = [ azurerm_virtual_network.Test-FW-VN ]
  
}
resource "azurerm_network_interface" "Srv-Work-NIC" {
  name = var.Srv-Work.interface
  ip_configuration {
    name = "IPConfig1"
    subnet_id = azurerm_subnet.Workload-SN.id
    private_ip_address_allocation = "Dynamic"
  }
  location = local.location
  resource_group_name = var.Test-FW-RG.name
  depends_on = [ azurerm_subnet.Workload-SN ]
  
}

resource "azurerm_windows_virtual_machine" "Srv-Work" {
  name = var.Srv-Work.name
  resource_group_name = var.Test-FW-RG.name
  location = local.location
  size = "Standard_B2S"
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"
  }
  network_interface_ids = [azurerm_network_interface.Srv-Work-NIC.id]
  admin_username = "nsdunkle"
  admin_password = "nsdunkle123321!"
  depends_on = [ azurerm_network_interface.Srv-Work-NIC ]
  
}

resource "azurerm_public_ip" "FWIP" {
  name = "FWIP"
  location = local.location
  resource_group_name = var.Test-FW-RG.name
  allocation_method = "Static"
  sku = "Standard"
  
}

resource "azurerm_firewall" "Test-FW01" {
  name = "Test-FW01"
  location = local.location
  resource_group_name = azurerm_resource_group.Test-FW-RG.name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
  ip_configuration {
    name = "FW_IPConfig"
    subnet_id = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.FWIP.id
  }
  depends_on = [ azurerm_public_ip.FWIP ]
}

resource "azurerm_route_table" "Firewall-route" {
  name = "Firewall-route"
  location = local.location
  resource_group_name = var.Test-FW-RG.name
  route {
    name = "DefaultRoute"
    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.4"
  }
  
}

resource "azurerm_subnet_route_table_association" "RT_Association" {
  subnet_id = azurerm_subnet.Workload-SN.id
  route_table_id = azurerm_route_table.Firewall-route.id
  
}
