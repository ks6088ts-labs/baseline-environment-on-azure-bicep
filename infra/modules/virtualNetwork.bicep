// Parameters
@description('Specifies the name of the virtual network.')
param virtualNetworkName string

@description('Specifies the address prefixes of the virtual network.')
param virtualNetworkAddressPrefixes string = '10.0.0.0/8'

@description('Specifies the name of the subnet which contains the virtual machine.')
param vmSubnetName string = 'VmSubnet'

@description('Specifies the address prefix of the subnet which contains the virtual machine.')
param vmSubnetAddressPrefix string = '10.3.1.0/24'

@description('Specifies the name of the network security group associated to the subnet hosting the virtual machine.')
param vmSubnetNsgName string = 'VmSubnetNsg'

@description('Specifies the Infrastructure subnet IP prefix. This prefix must be within vnet IP prefix address space.')
param infrastructureSubnetAddressPrefix string = '10.0.0.0/21'

@description('Specifies the Bastion subnet IP prefix. This prefix must be within vnet IP prefix address space.')
param bastionSubnetAddressPrefix string = '10.3.2.0/24'

@description('Specifies the name of the network security group associated to the subnet hosting Azure Bastion.')
param bastionSubnetNsgName string = 'AzureBastionNsg'

@description('Specifies whether Azure Bastion should be created.')
param bastionHostEnabled bool = true

@description('Specifies the name of the Azure Bastion resource.')
param bastionHostName string

@description('Enable/Disable Copy/Paste feature of the Bastion Host resource.')
param bastionHostDisableCopyPaste bool = false

@description('Enable/Disable File Copy feature of the Bastion Host resource.')
param bastionHostEnableFileCopy bool = false

@description('Enable/Disable IP Connect feature of the Bastion Host resource.')
param bastionHostEnableIpConnect bool = false

@description('Enable/Disable Shareable Link of the Bastion Host resource.')
param bastionHostEnableShareableLink bool = false

@description('Enable/Disable Tunneling feature of the Bastion Host resource.')
param bastionHostEnableTunneling bool = false

@description('Specifies the name of the Azure NAT Gateway.')
param natGatewayName string

@description('Specifies whether creating an Azure NAT Gateway for outbound connections.')
param natGatewayEnabled bool = false

@description('Specifies a list of availability zones denoting the zone in which Nat Gateway should be deployed.')
param natGatewayZones array = []

@description('Specifies the number of Public IPs to create for the Azure NAT Gateway.')
param natGatewayPublicIps int = 1

@description('Specifies the idle timeout in minutes for the Azure NAT Gateway.')
param natGatewayIdleTimeoutMins int = 30

@description('Specifies the name of the private link to the boot diagnostics storage account.')
param storageAccountPrivateEndpointName string = 'BlobStorageAccountPrivateEndpoint'

@description('Specifies the resource id of the Azure Storage Account.')
param storageAccountId string = ''

@description('Specifies the name of the private link to the Key Vault.')
param keyVaultPrivateEndpointName string = 'KeyVaultPrivateEndpoint'

@description('Specifies the resource id of the Azure Key vault.')
param keyVaultId string = ''

@description('Specifies the name of the private link to the Azure Container Registry.')
param acrPrivateEndpointName string = 'AcrPrivateEndpoint'

@description('Specifies the resource id of the Azure Container Registry.')
param acrId string = ''

@description('Specifies the name of the private link to the Azure OpenAI resource.')
param openAiPrivateEndpointName string = 'OpenAiPrivateEndpoint'

@description('Specifies the resource id of the Azure OpenAi.')
param openAiId string = ''

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

var storageAccountEnabled = !empty(storageAccountId)
var keyVaultEnabled = !empty(keyVaultId)
var acrEnabled = !empty(acrId)
var openAiEnabled = !empty(openAiId)

var infrastructureSubnetName = 'InfrastructureSubnet'
var bastionSubnetName = 'AzureBastionSubnet'
var bastionPublicIpAddressName = '${bastionHostName}PublicIp'
var vmSubnet = {
  name: vmSubnetName
  properties: {
    addressPrefix: vmSubnetAddressPrefix
    networkSecurityGroup: {
      id: vmSubnetNsg.id
    }
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
    natGateway: natGatewayEnabled ? {
      id: natGateway.id
    } : null
  }
}
var infrastructureSubnet = {
  name: infrastructureSubnetName
  properties: {
    addressPrefix: infrastructureSubnetAddressPrefix
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
var bastionSubnet = {
  name: bastionSubnetName
  properties: {
    addressPrefix: bastionSubnetAddressPrefix
    networkSecurityGroup: {
      id: bastionSubnetNsg.id
    }
  }
}
var subnets = union(
  array(vmSubnet),
  array(infrastructureSubnet),
  bastionHostEnabled ? array(bastionSubnet) : []
)

// Resources

// Network Security Groups
resource bastionSubnetNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = if (bastionHostEnabled) {
  name: bastionSubnetNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowLoadBalancerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '443'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource vmSubnetNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: vmSubnetNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowSshInbound'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefixes
      ]
    }
    subnets: subnets
  }
}

// NAT Gateway
resource natGatewayPublicIp 'Microsoft.Network/publicIPAddresses@2023-05-01' = [for i in range(0, natGatewayPublicIps): if (natGatewayEnabled) {
  name: natGatewayPublicIps == 1 ? '${natGatewayName}PublicIp' : '${natGatewayName}PublicIp${i + 1}'
  location: location
  sku: {
    name: 'Standard'
  }
  zones: !empty(natGatewayZones) ? natGatewayZones : []
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}]

resource natGateway 'Microsoft.Network/natGateways@2023-05-01' = if (natGatewayEnabled) {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  zones: !empty(natGatewayZones) ? natGatewayZones : []
  properties: {
    publicIpAddresses: [for i in range(0, natGatewayPublicIps): {
      id: natGatewayPublicIp[i].id
    }]
    idleTimeoutInMinutes: natGatewayIdleTimeoutMins
  }
  dependsOn: [
    natGatewayPublicIp
  ]
}

// Azure Bastion Host
resource bastionPublicIpAddress 'Microsoft.Network/publicIPAddresses@2023-05-01' = if (bastionHostEnabled) {
  name: bastionPublicIpAddressName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2023-05-01' = if (bastionHostEnabled) {
  name: bastionHostName
  location: location
  tags: tags
  properties: {
    disableCopyPaste: bastionHostDisableCopyPaste
    enableFileCopy: bastionHostEnableFileCopy
    enableIpConnect: bastionHostEnableIpConnect
    enableShareableLink: bastionHostEnableShareableLink
    enableTunneling: bastionHostEnableTunneling
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/${bastionSubnetName}'
          }
          publicIPAddress: {
            id: bastionPublicIpAddress.id
          }
        }
      }
    ]
  }
}

// Private DNS Zones
resource acrPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (acrEnabled) {
  name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'azurecr.us' : 'azurecr.io'}'
  location: 'global'
  tags: tags
}

resource blobPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (storageAccountEnabled) {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: 'global'
  tags: tags
}

resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (keyVaultEnabled) {
  name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'vaultcore.usgovcloudapi.net' : 'vaultcore.azure.net'}'
  location: 'global'
  tags: tags
}

resource openAiPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = if (openAiEnabled) {
  name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'openai.usgovcloudapi.net' : 'openai.azure.com'}'
  location: 'global'
  tags: tags
}

// Virtual Network Links
resource acrPrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (acrEnabled) {
  parent: acrPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource blobPrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (storageAccountEnabled) {
  parent: blobPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource keyVaultPrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (keyVaultEnabled) {
  parent: keyVaultPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource openAiPrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (openAiEnabled) {
  parent: openAiPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// Private Endpoints
resource acrPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = if (acrEnabled) {
  name: acrPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: acrPrivateEndpointName
        properties: {
          privateLinkServiceId: acrId
          groupIds: [
            'registry'
          ]
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/${vmSubnetName}'
    }
  }
}

resource acrPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = if (acrEnabled) {
  parent: acrPrivateEndpoint
  name: 'acrPrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: acrPrivateDnsZone.id
        }
      }
    ]
  }
}

resource blobStorageAccountPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = if (storageAccountEnabled) {
  name: storageAccountPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: storageAccountPrivateEndpointName
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [
            'blob'
          ]
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/${vmSubnetName}'
    }
  }
}

resource blobStorageAccountPrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = if (storageAccountEnabled) {
  parent: blobStorageAccountPrivateEndpoint
  name: 'PrivateDnsZoneGroupName'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: blobPrivateDnsZone.id
        }
      }
    ]
  }
}

resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = if (keyVaultEnabled) {
  name: keyVaultPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: keyVaultPrivateEndpointName
        properties: {
          privateLinkServiceId: keyVaultId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/${vmSubnetName}'
    }
  }
}

resource keyVaultPrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = if (keyVaultEnabled) {
  parent: keyVaultPrivateEndpoint
  name: 'PrivateDnsZoneGroupName'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: keyVaultPrivateDnsZone.id
        }
      }
    ]
  }
}

resource openAiPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = if (openAiEnabled) {
  name: openAiPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: openAiPrivateEndpointName
        properties: {
          privateLinkServiceId: openAiId
          groupIds: [
            'account'
          ]
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/${vmSubnetName}'
    }
  }
}

resource openAiPrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = if (openAiEnabled) {
  parent: openAiPrivateEndpoint
  name: 'PrivateDnsZoneGroupName'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: openAiPrivateDnsZone.id
        }
      }
    ]
  }
}

// Outputs
output virtualNetworkId string = vnet.id
output virtualNetworkName string = vnet.name
output vmSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, vmSubnetName)
output bastionSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, bastionSubnetName)
output vmSubnetName string = vmSubnetName
output bastionSubnetName string = bastionSubnetName
output infrastructureSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, infrastructureSubnetName)
