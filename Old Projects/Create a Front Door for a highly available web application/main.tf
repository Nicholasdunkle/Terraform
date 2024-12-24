locals {
  location1 = "Central US"
  location2 = "East US"
}

resource "azurerm_resource_group" "CentralRG" {
  name = var.ResourceGroupCentral.name
  location = local.location1
  
}

resource "azurerm_service_plan" "ASP-Central" {
  name = var.ASP-Central.name
  os_type = var.ASP-Central.os_type
  sku_name = var.ASP-Central.sku_name
  resource_group_name = var.ResourceGroupCentral.name
  location = local.location1
  depends_on = [ azurerm_resource_group.CentralRG ]
  
}

resource "azurerm_service_plan" "ASP-East" {
  name = var.ASP-East.name
  os_type = var.ASP-East.os_type
  sku_name = var.ASP-East.sku_name
  resource_group_name = var.ResourceGroupCentral.name
  location = local.location2
  depends_on = [ azurerm_resource_group.CentralRG ]
  
}

resource "azurerm_windows_web_app" "Webapp1" {
  name = "Webapp1-nsdunkle"
  location = local.location1
  resource_group_name = var.ResourceGroupCentral.name
  service_plan_id = azurerm_service_plan.ASP-Central.id
  site_config {
    
  }
  depends_on = [ azurerm_service_plan.ASP-Central ]
}

resource "azurerm_windows_web_app" "Webapp2" {
  name = "Webapp2-nsdunkle"
  location = local.location2
  resource_group_name = var.ResourceGroupCentral.name
  service_plan_id = azurerm_service_plan.ASP-East.id
  site_config {
    
  }
  depends_on = [ azurerm_service_plan.ASP-East ]
}

resource "azurerm_cdn_frontdoor_profile" "nsdunkle-frontend" {
  name = "nsdunkle-frontend"
  resource_group_name = var.ResourceGroupCentral.name
  sku_name = "Standard_AzureFrontDoor"
  
}



resource "azurerm_cdn_frontdoor_origin_group" "OG1" {
  name = "origingroup1"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.nsdunkle-frontend.id
  session_affinity_enabled = false
  load_balancing {
    
  }
  
}

resource "azurerm_cdn_frontdoor_origin" "Origin" {
  name = "nsdunkleFDOrigin"
  certificate_name_check_enabled = false
  host_name = "nsdunkle-fd.com"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.OG1.id
  
}

resource "azurerm_cdn_frontdoor_endpoint" "FDEP" {
  name = "nsdunkle-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.nsdunkle-frontend.id
  
}




