output "subnets" {
  value       = module.xNetwork.Subnets
  description = "Returns the complete set of NSG objects created in the virtual network"
}

output "NSGs" {
  value       = module.xSecurityGroup.NSGs
  description = "Returns the complete set of NSG objects created in the virtual network"
}



