output "Subnets" {
  value = azurerm_subnet.coreInfra
}
output "NSGIds" {
  value = azurerm_network_security_group.this.*
}

output "NSGs" {
  value = azurerm_network_security_group.this
}
output "Tables" {
  value = azurerm_route_table.this
}

  