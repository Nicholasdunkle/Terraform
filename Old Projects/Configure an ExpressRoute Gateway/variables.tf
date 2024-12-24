
variable "resourcegroup_Contoso" {
  type = object({
    name     = string
    location = string 
  })
  default = {
    name     = "ContosoResourceGroup"
    location = "East US"
  }
}

variable "Vnet_CoreServices" {
  type = object({
    name = string
    location = string
    resource_group_name = string
    address_space = list(string)
  })  
  default = {
    name = "CoreServicesVnet"
    location = "East US"
    resource_group_name = "ContosoResourceGroup" 
    address_space = [ "10.20.0.0/16" ]
  }
  
}

variable "subnet_GatewaySubnet" {
  type = object({
    name = string
    address_prefix = list(string) 
  })
  default = {
    name = "GatewaySubnet"
    address_prefix = [ "10.20.0.0/27" ]
  }
}

variable "VNG_CoreServicesVnetGateway" {
  default = {
    name = "CoreServicesVnetGateway"
    location = "East US"
    resource_group_name = "ContosoResourceGroup"
    sku = "Standard"
    type = "ExpressRoute"
  }
  
}
