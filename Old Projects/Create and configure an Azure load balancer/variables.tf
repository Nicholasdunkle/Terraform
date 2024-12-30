variable "Resourcegroup_IntLB-RG" {
  default = {
    name = "IntLB-RG"
  }
}

variable "Vnet_IntLB-Vnet" {
  default = {
    name = "IntLB-Vnet"
    address_space = ["10.1.0.0/16"]
  }
}

variable "Subnet_myBackendSubnet" {
  default = {
    name = "myBackendSubnet"
    address_prefix = ["10.1.0.0/24"]
  }
  
}


variable "Virtualmachine_TestVM" {
  default = {
    admin_password = "G7k#8vPz!2Lm"
    admin_username = "nsdunkle"
    name = "TestVM"
    size = "Standard_B2s"
  }
  
}

variable "Loadbalancer_myIntLoadBalancer"  {
  default = {
    name = "myIntLoadBalancer"
  }
  
}
