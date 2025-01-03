resource "azurerm_network_interface" "dbinterfaces" {
    for_each = var.app_environment.production.subnets["dbsubnet"].machines
    name = each.value.networkinterfacename
    location = local.resource_location
    resource_group_name = azurerm_resource_group.app-grp.name
    ip_configuration {
      name = "internal"
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.app-network-subnets["dbsubnet"].id
      public_ip_address_id = azurerm_public_ip.dbip[each.key].id
    }
  
}

resource "azurerm_public_ip" "dbip" {
    for_each = var.app_environment.production.subnets["dbsubnet"].machines
    name = each.value.publicipaddressname
    resource_group_name = azurerm_resource_group.app-grp.name
    location = local.resource_location
    allocation_method = "Static"
  
}

resource "azurerm_linux_virtual_machine" "dbvm" {
    for_each = var.app_environment.production.subnets.dbsubnet.machines
    name = each.key
    resource_group_name = azurerm_resource_group.app-grp.name
    location = local.resource_location
    size = "Standard_B1s"
    admin_username = "linuxadmin"
    admin_password = var.adminpassword
    disable_password_authentication = false
    custom_data = data.local_file.cloudinit.content_base64
    network_interface_ids = [ azurerm_network_interface.dbinterfaces[each.key].id ]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts"
      version = "latest"
    }
}

data "local_file" "cloudinit" {
  filename = "cloudinit"
}
