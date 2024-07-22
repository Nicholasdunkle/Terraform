variable "resourcegroup_Contoso" {
  type    = object({
    name     = string
    location = string
  })
  default = {
    name     = "ContosoResourceGroup"
    location = "East US"
  }
  description = "Details for Contoso's Azure Resource Group"
}


variable "Vnet_ContosoVnet" {
    type = object({
      name = string
      location = string 
      address_space = list(string)
    })
    default = {
        name = "ContosoVnet"
        location = "West US"
        address_space = ["10.60.0.0/16"]
        
    }
}

variable "Vnet_Research" {
    type = object({
      name = string
      location = string
      address_space = list(string)
    })
    default = {
        name = "ResearchVnet"
        location = "Southeast Asia"
        address_space = [ "10.40.0.0/16" ]
    }
  
}

variable "Researchsubnet" {
  type = object({
    name = string
    location = string
    address_prefix = list(string)
  })
  default = {
    name = "ResearchSystemSubnet"
    location = "Southeast Asia"
    address_prefix = [ "10.40.0.0/24" ]
  }
  
}

variable "VirtualWAN_Contoso" {
    type = object({
      name = string
      location = string
      resource_group_name = string
       })
    default = {
        name = "ContosoVirtualWAN"
        location = "West US"
        resource_group_name = "ContosoResourceGroup"
    }
   
  
}