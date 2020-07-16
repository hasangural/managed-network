output "NSGIds" {
  value = azurerm_network_security_group.coreInfra.*
}

output "NSGs" {
  value = azurerm_network_security_group.coreInfra
}