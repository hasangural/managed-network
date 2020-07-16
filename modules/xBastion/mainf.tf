
####> Creating Resource Group for Managed Bastion Infrastructure <####

resource "azurerm_resource_group" "ManagedBastion" {
  count = var.vNetworkSettings.RequiredBastionHost ? 1 : 0

  name     = "${var.ServiceId}-${var.EnvironmentInstanceId}-bst-${var.InstanceId}"
  location = var.Region
}

####> Creating Public IP for Managed Bastion Infrastructure <####

resource "azurerm_public_ip" "ManagedBastion" {
  count = var.vNetworkSettings.RequiredBastionHost ? 1 : 0

  name                = "${var.ServiceId}-${var.EnvironmentInstanceId}-mgmt-bst-${var.InstanceId}-pip"
  location            = var.Region
  resource_group_name = azurerm_resource_group.ManagedBastion[0].name
  allocation_method   = "Static"
  sku                 = "Standard" # Zone redundant

}

resource "azurerm_bastion_host" "ManagedBastion" {
  name                = "${var.ServiceId}-${var.EnvironmentInstanceId}-mgmt-bst-${var.InstanceId}"
  location            = var.Region
  resource_group_name = azurerm_resource_group.ManagedBastion[0].name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.vSubnetsSettings.BastionSubnet.id
    public_ip_address_id = azurerm_public_ip.ManagedBastion[0].id
  }
  count = var.vNetworkSettings.RequiredBastionHost ? 1 : 0
}
