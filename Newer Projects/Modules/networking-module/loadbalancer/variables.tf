variable "resource_group_name" {
  type= string
  description = "This defines the name of the resource group"
}

variable "location" {
  type= string
  description = "This defines the location of the resource group and the resources"
}

variable "number_of_machines" {
    type = number
    description = "number of machines in backend pool"
}

variable "virtual_network_id" {
    type = string
    description = "value"
}

variable "network_interface_private_ip_address" {
    type = list(string)
  
}
