resource "azurerm_resource_group" "appgrp" {
  name = "app-grp"
  location = local.location
  
}

resource "azurerm_service_plan" "serviceplan" {
  for_each = var.webapp_environment.production.serviceplan
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.location
  os_type             = each.value.os_type
  sku_name            = each.value.sku
}

resource "azurerm_windows_web_app" "webapp" {
  for_each = var.webapp_environment.production.serviceapp
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.location
  service_plan_id     = azurerm_service_plan.serviceplan[each.value].id

  site_config {
    
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v9.0"
    }
}
logs {
  detailed_error_messages = true
  http_logs {
    azure_blob_storage {
      retention_in_days = 7
      sas_url = "https://${azurerm_storage_account.nsdunklestorageaccount.name}.blob.core.windows.net/${azurerm_storage_container.weblogs.name}${data.azurerm_storage_account_sas.storagesas.sas}"
    }
  }

}
  tags = local.production_tags
}



