// Parameters
@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id, location)

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the Azure Computer Vision resource')
param containerRegistryName string = '${prefix}containerregistry'

@description('Specifies the Computer Vision SKU.')
param containerRegistrySkuName string = 'Basic'

module containerRegistry 'br/public:compute/container-registry:1.1.1' = {
  name: 'containerRegistry'
  params: {
    name: containerRegistryName
    location: location
    tags: tags
    skuName: containerRegistrySkuName
  }
}

output containerRegistryName string = containerRegistry.name
