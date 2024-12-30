variable "ContosoResourceGroup" {
  default = {
    name = "ContosoResourceGroup"
  }
  
}

variable "ContosoVnet" {
  default = {
    name = "ContosoVnet"
    address_space = ["10.0.0.0/16"]
  }
  
}

variable "BEVM1" {
  default = {
    name = "BackendVM1"
    size = "Standard_B2s"
    admin_username = "nsdunkle"
    admin_password = "password123!"
  }
  
}

variable "BEVM2" {
  default = {
    name = "BackendVM2"
  }
}

variable "VnetGateway_CoreServices" {
  default = {
    name = "CoreServicesVnetGateway"
    
  }
  
}



