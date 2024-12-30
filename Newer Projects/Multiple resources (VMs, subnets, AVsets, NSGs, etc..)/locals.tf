locals {
  resource_location = "Central US"
  virtual_network = {
    name = "app-network"
    address_prefixes = ["10.0.0.0/16"]
  }
}
