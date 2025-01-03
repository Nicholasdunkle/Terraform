variable "app_environment" {
  type = map(object(
    {
    virtualnetworkname = string
    virtualnetworkcidrblock = string
    subnets=map(object(
      {
      cidrblock = string
      machines=map(object(
        {
        networkinterfacename=string
        publicipaddressname=string 
      })) 
    })) 
  }))
  
}

variable "adminpassword" {
  type = string
  description = "Admin password for virtual machine"
  sensitive = true
  
}