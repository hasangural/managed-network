locals {
  Rules = {
    Properties = ["name", "priority", "direction", "access", "protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"]
    NSGIngress = [
      # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" },
      ["AllowAzureLoadBalancerInBound", "4095", "Inbound", "Allow", "*", "*", "*", "AzureLoadBalancer", "*"],
      ["AllowVnetIBound", "4096", "Inbound", "Deny", "*", "*", "*", "*", "*"]
    ],
    NSGEgress = [
      ["DenyVnetOutBound", "4096", "Outbound", "Deny", "*", "*", "*", "*", "*"],
    ]
  }
  Merge = concat(local.Rules.NSGIngress)
}

####> Creating Resource Group for Core Infrastructure <####

resource "azurerm_resource_group" "coreInfra" {

  name     = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  location = var.Region
}

####> Creating Virutal Network for Core Infrastructure <####

resource azurerm_virtual_network "coreInfra" {

  name                = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-vn-${var.InstanceId}"
  resource_group_name = azurerm_resource_group.coreInfra.name
  location            = var.Region

  address_space       = var.vNetworkSettings.vNetRange
  dns_servers         = var.vNetworkSettings.vDNSSettings.RequiredDNS == true ? var.vNetworkSettings.vDNSSettings.vDNSServers : []
}

####> Creating Virutal Network Subnets for Core Infrastructure <####

resource "azurerm_subnet" "coreInfra" {
  for_each = var.vSubnetsSettings

  name                                           = each.value.Name
  resource_group_name                            = azurerm_resource_group.coreInfra.name
  virtual_network_name                           = azurerm_virtual_network.coreInfra.name
  address_prefix                                 = each.value.Range
  service_endpoints                              = lookup(each.value, "ServiceEndpoints", [])
  enforce_private_link_endpoint_network_policies = lookup(each.value, "EnforcePrivateLinkEdpointPolicies", null)
  enforce_private_link_service_network_policies  = lookup(each.value, "EnforcePrivateLinkServicePolicies", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "Delegation", {}) != {} ? [1] : []

    content {
      name = lookup(each.value.Delegation, "Name", null)

      service_delegation {
        name    = lookup(each.value.Delegation.ServiceDelegation, "Name", null)
        actions = lookup(each.value.Delegation.ServiceDelegation, "Actions", null)
      }
    }
  }
}

####> Creating NSGs for Subnets for Core Infrastructure <####

resource "azurerm_network_security_group" "this" {

  for_each = { for name, v in var.vSubnetsSettings : name => v if v.RequiredSecurityGroup == true }

  name                = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-nsg-${lower(each.value.Name)}"
  resource_group_name = azurerm_resource_group.coreInfra.name
  location            = var.Region

  dynamic "security_rule" {

    for_each = concat(lookup(each.value, "NSGIngress", []), lookup(each.value, "NSGEgress", []), local.Merge)
    content {
      name                       = security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2]
      access                     = security_rule.value[3]
      protocol                   = security_rule.value[4]
      source_port_range          = security_rule.value[5]
      #source_port_ranges         = security_rule.value[5]
      destination_port_range     = security_rule.value[6]
      source_address_prefix      = security_rule.value[7]
      destination_address_prefix = security_rule.value[8]

    }
  }
}

####> Creating NSGs for Subnets for Core Infrastructure <####

resource "azurerm_route_table" "this" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredInernetAccess == true && v.RequiredNetworkAccess == true }

  name                          = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  resource_group_name           = azurerm_resource_group.coreInfra.name
  location                      = var.Region
  disable_bgp_route_propagation = true

  route {
    name           = "route1"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  tags = {
    environment = "Production"
  }
}


