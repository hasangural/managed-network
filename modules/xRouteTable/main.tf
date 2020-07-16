resource "azurerm_route_table" "coreInfra" {
  for_each = { for name, v in var.vSubnetsSettings : name => v.Name if v.RequiredInernetAccess == true && v.RequiredNetworkAccess == true }

  name                          = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-rt-${lower(each.value)}"
  resource_group_name           = "${var.ServiceId}-${var.EnvironmentInstanceId}-core-${var.InstanceId}"
  location                      = var.Region
  disable_bgp_route_propagation = true
  depends_on                    = [var.DependsOn]

  route {
    name           = "route1"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  route {
    name           = "route2"
    address_prefix = "10.2.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  tags = {
    environment = "Production"
  }
}


