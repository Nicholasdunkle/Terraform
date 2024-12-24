variable "network_interface_count" {
  type = number
}

variable "subnet_information" {
    type = map(object({
      cidrblock = string
    }))
  
}
