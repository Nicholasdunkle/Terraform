locals {
  location1 = "East US"
  location2 = "West Europe"
}

resource "azurerm_resource_group" "RG1" {
  name = var.Resourcegroup_RG1.name
  location = var.Resourcegroup_RG1.location
  
}

resource "azurerm_service_plan" "myAppServicePlanEastUS" {
  name = var.ASP_myAppServicePlanEastUS.name
  sku_name = var.ASP_myAppServicePlanEastUS.sku_name
  os_type = var.ASP_myAppServicePlanEastUS.os_type
  location = local.location1
  resource_group_name = var.Resourcegroup_RG1.name
  
}

resource "azurerm_service_plan" "myAppServicePlanWestEurope" {
  name = var.ASP_myAppServicePlanWestEurope.name
  sku_name = var.ASP_myAppServicePlanWestEurope.sku_name
  os_type = var.ASP_myAppServicePlanWestEurope.os_type
  location = local.location2
  resource_group_name = var.Resourcegroup_RG1.name
  
}

resource "azurerm_windows_web_app" "myWebAppEastUS" {
  name = "myWebAppEastUSnsdunkle"
  resource_group_name = var.Resourcegroup_RG1.name
  location = local.location1
  service_plan_id = azurerm_service_plan.myAppServicePlanEastUS.id
  site_config {
    
  }

}

resource "azurerm_windows_web_app" "myWebAppWestEurope" {
  name = "myWebAppWestEuropensdunkle"
  resource_group_name = var.Resourcegroup_RG1.name
  location = local.location2
  service_plan_id = azurerm_service_plan.myAppServicePlanWestEurope.id
  site_config {
    
  }

}

resource "azurerm_traffic_manager_profile" "myTMProfile" {
  name = var.TrafficManagerProfile.name
  resource_group_name = var.Resourcegroup_RG1.name
  traffic_routing_method = "Priority"
  dns_config {
    relative_name = "Contoso-TMProfilensdunkle"
    ttl = 100
  }
  monitor_config {
    protocol = "HTTPS"
    port = 443
    path = "/"
  }
}

resource "azurerm_public_ip" "PIP1" {
  name                = "PIP1"
  location            = local.location1
  resource_group_name = var.Resourcegroup_RG1.name
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = "pip1-dns"
}

resource "azurerm_public_ip" "PIP2" {
  name                = "PIP2"
  location            = local.location2
  resource_group_name = var.Resourcegroup_RG1.name
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = "pip2-dns"
}

resource "azurerm_traffic_manager_azure_endpoint" "myPrimaryEndpoint" {
  name                 = "myPrimaryEndpoint"
  profile_id           = azurerm_traffic_manager_profile.myTMProfile.id
  target_resource_id   = azurerm_public_ip.PIP1.id
  priority = 1
}

resource "azurerm_traffic_manager_azure_endpoint" "myFailoverendpoint" {
  name                 = "myFailoverendpoint"
  profile_id           = azurerm_traffic_manager_profile.myTMProfile.id
  target_resource_id   = azurerm_public_ip.PIP2.id
  priority = 2
}
