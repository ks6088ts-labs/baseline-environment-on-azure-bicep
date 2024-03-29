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

@description('Specifies the Bastion subnet IP prefix. This prefix must be within vnet IP prefix address space.')
param bastionSubnetAddressPrefix string = '10.3.2.0/24'

@description('Specifies the name of the network security group associated to the subnet hosting Azure Bastion.')
param bastionSubnetNsgName string = 'AzureBastionNsg'

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

@description('Specifies the name of the private link to the Azure OpenAI resource.')
param openAiPrivateEndpointName string = 'OpenAiPrivateEndpoint'

@description('Specifies the resource id of the Azure OpenAi.')
param openAiId string

@description('Specifies the name of the private link to the Azure Cognitive Search resource.')
param cognitiveSearchPrivateEndpointName string = 'CognitiveSearchPrivateEndpoint'

@description('Specifies the resource id of the Azure Cognitive Search.')
param cognitiveSearchId string

@description('Specifies the name of the private link to the App Service.')
param appServicePrivateEndpointName string = 'AppServicePrivateEndpoint'

@description('Specifies the resource id of the App Service.')
param appServiceId string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

// Variables
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
  array(bastionSubnet)
)

// Resources

// Network Security Groups
resource bastionSubnetNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
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

resource vmSubnetNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
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
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
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

// Azure Bastion Host
resource bastionPublicIpAddress 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
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

resource bastionHost 'Microsoft.Network/bastionHosts@2023-09-01' = {
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

resource openAiPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'openai.usgovcloudapi.net' : 'openai.azure.com'}'
  location: 'global'
  tags: tags
}

resource openAiPrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
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

resource openAiPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
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

resource openAiPrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = {
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

resource cognitiveSearchPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.search.windows.net'
  location: 'global'
  tags: tags
}

resource cognitiveSearchPrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: cognitiveSearchPrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource cognitiveSearchPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: cognitiveSearchPrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: cognitiveSearchPrivateEndpointName
        properties: {
          privateLinkServiceId: cognitiveSearchId
          groupIds: [
            'searchService'
          ]
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/${vmSubnetName}'
    }
  }
}

resource cognitiveSearchPrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = {
  parent: cognitiveSearchPrivateEndpoint
  name: 'PrivateDnsZoneGroupName'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: cognitiveSearchPrivateDnsZone.id
        }
      }
    ]
  }
}

resource appServicePrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'
  tags: tags
}

resource appServicePrivateDnsZoneVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: appServicePrivateDnsZone
  name: 'link_to_${toLower(virtualNetworkName)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource appServicePrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: appServicePrivateEndpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: appServicePrivateEndpointName
        properties: {
          privateLinkServiceId: appServiceId
          groupIds: [
            'sites'
          ]
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/${vmSubnetName}'
    }
  }
}

resource appServicePrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = {
  parent: appServicePrivateEndpoint
  name: 'PrivateDnsZoneGroupName'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'dnsConfig'
        properties: {
          privateDnsZoneId: appServicePrivateDnsZone.id
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
