locals {
  resource_location = "Central US"
  virtual_network = {
    name = "app-network"
    address_prefixes = ["10.0.0.0/16"]
  }
  subnets = {
    names = ["websubnet01","appsubnet01"]
    address_prefixes = ["10.0.0.0/24", "10.0.1.0/24"]
  }
}
