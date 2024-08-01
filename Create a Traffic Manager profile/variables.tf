variable "Resourcegroup_RG1" {
  default = {
    name = "RG1"
    location = "East US"

  }
  
}

variable "ASP_myAppServicePlanEastUS" {
  default = {
    name = "myAppServicePlanEastUS"
    sku_name = "P1v2"
    os_type = "Windows"
  }
  
}

variable "ASP_myAppServicePlanWestEurope" {
  default = {
    name = "myAppServicePlanWestEurope"
    sku_name = "P1v2"
    os_type = "Windows"
  }
  
}

variable "TrafficManagerProfile" {
  default = {
  name = "myTMProfile"
  traffic_routing_method = "Priority"
  }

}


