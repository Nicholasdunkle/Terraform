variable "Test-FW-RG" {
    default = {
        name = "Test-FW-RG"
    }
  
}

variable "Test-FW-VN" {
    default = {
        name = "Test-FW-VN"
        address_space = ["10.0.0.0/16"]
    }
  
}

variable "Workload-SN" {
    default = {
        name = "Workload-SN"

    }
  
}

variable "AzureFirewallSubnet" {
    default = {
        name = "AzureFirewallSubnet"
    }
  
}

variable "Srv-Work" {
    default = {
        name = "Srv-Work"
        interface = "Srv-Work-NIC"

    }
  
}
