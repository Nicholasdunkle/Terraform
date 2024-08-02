variable "ResourceGroupCentral" {
  default = {
    name = "CentralRG"
  }
}


variable "ASP-Central" {
  default = {
    name = "myAppServicePlanCentralUS"
    os_type = "Windows"
    sku_name = "B1"
  }
}

variable "ASP-East" {
  default = {
    name = "myAppServicePlanEast"
    os_type = "Windows"
    sku_name = "B1"
  }
}
