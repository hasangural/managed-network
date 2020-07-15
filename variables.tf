variable "SubscriptionId" {
  description = "Please Provide your subscriptionId"
  default     = ""
}
variable "TenantId" {
  description = "Please Provide your tenantId"
  default     = ""
}

variable "ClientId" {
  description = "Please Provide your clientId"
  default     = ""
}

variable "SecretKey" {
  description = "Please Provide your secretKey"
  default     = ""
}

variable "ServiceId" {
  description = "This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B)"
  default     = ""
}

variable "EnvironmentInstanceId" {
  description = "This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B)This parameters is referred to as the resource EnvironmentInstanceId which includes Env and InstanceId. Example: p01, t01"
  default     = ""
}

variable "InstanceId" {
  description = "This parameters is referred to as the resource prefix and describes service names. Example: Platform(P) - Business(B)This parameters is referred to as the resource EnvironmentInstanceId which includes Env and InstanceId. Example: p01, t01"
  default     = ""
}
variable "Region" {
  description = "This parameters is referred to Resource Location"
  default     = ""
}
variable "Tags" {
  description = "This parameters is referred to Resource Location"
  default = {
    "Environment" = "dev"
    "CostCenter " = "12838201"
  }
}

variable "vNetworkSettings" {
  type = object({
    vNetRange = list(string)
    vDNSSettings = object({
      RequiredDNS = bool
      vDNSServers = list(string)
    })
    vNetPeeringSettings = object({
      RequiredInternetAccess = bool
      RequiredNetworkAccess  = bool
    })

  })
}
variable "vSubnetsSettings" {
  default = ""
}
