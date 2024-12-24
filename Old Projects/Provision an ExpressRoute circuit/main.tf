resource "azurerm_resource_group" "Contoso" {
  name = var.resourcegroup_Contoso.name
  location = var.resourcegroup_Contoso.location
} 

resource "azurerm_resource_group" "ExpressRoute" {
  name = var.resourcegroup_Expressroute.name
  location = var.resourcegroup_Expressroute.location
  
}

resource "azurerm_virtual_network" "CoreServices" {
  name = var.Vnet_CoreServices.name
  location = var.Vnet_CoreServices.location
  resource_group_name = var.resourcegroup_Contoso.name
  address_space = var.Vnet_CoreServices.address_space

  
}

resource "azurerm_subnet" "GatewaySubnet" {
  name = var.subnet_GatewaySubnet.name
  resource_group_name = var.resourcegroup_Contoso.name
  virtual_network_name = var.Vnet_CoreServices.name
  address_prefixes = var.subnet_GatewaySubnet.address_prefix
  
}

resource "azurerm_public_ip" "PIP1" {
  name = "PIP1"
  resource_group_name = var.VNG_CoreServicesVnetGateway.resource_group_name
  location = var.resourcegroup_Contoso.location
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_virtual_network_gateway" "CoreServicesVnetGateway" {
  name = var.VNG_CoreServicesVnetGateway.name
  location = var.VNG_CoreServicesVnetGateway.location
  resource_group_name = var.VNG_CoreServicesVnetGateway.resource_group_name
  sku = var.VNG_CoreServicesVnetGateway.sku
  type = var.VNG_CoreServicesVnetGateway.type
  ip_configuration {
    name = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.PIP1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.GatewaySubnet.id
  }
  depends_on = [ azurerm_public_ip.PIP1 ]
  
}

resource "azurerm_express_route_circuit" "ExpressRouteCircuit" {
  name = var.expressroute_circuit.name
  resource_group_name = var.expressroute_circuit.resource_group_name
  location = var.expressroute_circuit.location
  service_provider_name = "Equinix"
  peering_location = "Seattle"
  bandwidth_in_mbps = 50
  sku {
    tier = var.expressroute_circuit.sku
    family = "MeteredData"
  }

  
}

