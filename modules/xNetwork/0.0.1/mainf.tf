locals {

  ManagedBastion = {
    "Subnet99" = {
      Name                              = "AzureBastionSubnet"
      Range                             = cidrsubnet("10.10.20.0/24", 4, 15)
      RequiredInernetAccess             = false
      RequiredNetworkAccess             = false
      RequiredSecurityGroup             = true
      ServiceEndpoints                  = [] #[You can add multiple Service Endpoints for spesific Subnets "Microsoft.EventHub"]#
      EnforcePrivateLinkEdpointPolicies = false
      EnforcePrivateLinkServicePolicies = false
      NSGIngress = [
        # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range(s)", "destination_port_range(s)", "source_address_prefix(s)", "destination_address_prefix(s)" },
      ]
      NSGEgress = [
        # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range(s)", "destination_port_range(s)", "source_address_prefix(s)", "destination_address_prefix(s)" },
        # ["AllowAzureLoadBalancerInBound", "4095", "OutBound", "Allow", "*", "*", "*", "AzureLoadBalancer", "*"]
      ]
    }
  }

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

####> Creating Virutal Subnets for Core Infrastructure <####

resource "azurerm_subnet" "coreInfra" {
  for_each = merge(var.vSubnetsSettings, var.DeployManagedBastion == true ? local.ManagedBastion : {}) 

  name                 = each.value.Name
  resource_group_name  = azurerm_resource_group.coreInfra.name
  virtual_network_name = azurerm_virtual_network.coreInfra.name
  address_prefix       = each.value.Range
  service_endpoints    = lookup(each.value, "ServiceEndpoints", [])
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
