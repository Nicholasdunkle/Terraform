resource "azurerm_storage_account" "nsdunklestorageaccount" {
    name = "nsdunklestorageaccount"
    resource_group_name = azurerm_resource_group.appgrp.name
    location = local.location
    account_tier = "Standard"
    account_replication_type = "LRS"
    account_kind = "StorageV2"
  
}

resource "azurerm_storage_container" "weblogs" {
    name = "weblogs"
    storage_account_id = azurerm_storage_account.nsdunklestorageaccount.id
    container_access_type = "blob"
  
}

data "azurerm_storage_account_sas" "storagesas" {
  connection_string = azurerm_storage_account.nsdunklestorageaccount.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2024-12-24T00:00:00Z"
  expiry = "2025-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}
