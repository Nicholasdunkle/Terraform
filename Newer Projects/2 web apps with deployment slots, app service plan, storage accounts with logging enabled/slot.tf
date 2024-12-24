resource "azurerm_windows_web_app_slot" "webapp_slot" {
  name           = var.webapp_slot[1]
  app_service_id = azurerm_windows_web_app.webapp["${var.webapp_slot[0]}"].id

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v9.0"
    }
  }
}

resource "azurerm_web_app_active_slot" "activeslot" {
    slot_id = azurerm_windows_web_app_slot.webapp_slot.id
  
}
