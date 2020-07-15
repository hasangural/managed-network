<p align="center">
    <img alt="MsHowto" src="https://ifi.tech/wp-content/uploads/2020/03/Terraform-with-Azure.png" width="250" />
  </a>
</p>
<h1 align="center">
  Managed Virtual Network Module of Common Platform Services within Terraform
</h1>

<h3 align="center">
  ⚛️ 📄 🚀
</h3>
<h3 align="center">
  This document will be covering also combination of using Managed Network resources like RouteTables, NSGs, Peerings, Flows, Monitorings within the Terrraform
</h3>

- [What’s In This Document](#whats-in-this-document)
- [Inputs of Managed Virtual Network](#inputs-of-managed-virtual-network)

## What’s In This Document
This document is intended  to explain custom Terraform Module for using Managed Network purpose. It will deploy fully configured and ready to use compliance virtual network for any purpose of using it. 

You can create a virtual network with this module. Also you can manage these resources;

*   DNS Settings on the Virtual Network
*   Subnet creation on the Virtual Network
*   NSG creation on the Virtual Network
*   URDs creation on 
*   DDoS protection attachment on the Virtual Network
*   Network Watcher Flow Logs and Traffic Analytics Settings on the Virtual Network
*   Diagnostics logging for the Virtual Network
*   Diagnostics logging for the each Sub-Networks
*   Diagnostics logging for the Network Security Groups

Reference the module to a specific version (recommended):
```hcl

    module "AzNetwork" {

    source = "./modules/Az.Network/0.0.1"
    #version = "0.0.1"

    ServiceId             = var.ServiceId
    EnvironmentInstanceId = var.EnvironmentInstanceId
    InstanceId            = var.InstanceId

    Region                = var.Region
    vNetworkSettings      = var.vNetworkSettings
    vSubnetsSettings      = var.vSubnetsSettings

}
```

## Inputs of Managed Virtual Network 

| Name                   | Type   | Default |  Description |
| --                     | --     | --      |    --        |
| ServiceId              | string | None    |  (Required) This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B). |
| EnvironmentInstanceId  | string | None    |  (Required) This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B). |
| InstanceId             | string | None    |  (Required) This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B). |
| Region                 | string | None    |  (Required) This parameters is referred to Resource Location. |
| Tags                   | object | None    |  (Required) This parameters is referred to Resource Tags. |
| vNetworkSettings       | object | None    |  (Required) This parameters is referred to Resource Tags. |



| | |
|-|-|
|`NOTE` |  You can follow your own entire range of `IP Addresses`. All of this completely an example.|