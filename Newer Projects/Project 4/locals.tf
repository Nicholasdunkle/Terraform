locals {
  resource_location = "Central US"
  networksecuritygrouprules = [{
    priority = 300
    destination_port_range = "22"
  }]
}
