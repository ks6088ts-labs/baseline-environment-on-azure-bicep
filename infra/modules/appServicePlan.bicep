// Parameters
@description('Name of your App Service Plan.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the kind of the App Service Plan. Allowed values are linux, functionapp, elasticpremium, virtualmachine, windows.')
@allowed([
  'linux'
  'functionapp'
  'elasticpremium'
  'virtualmachine'
  'windows'
])
param kind string = 'linux'

@description('Optional S1 is default. Defines the name, tier, size, family and capacity of the App Service Plan. Plans ending to _AZ, are deploying at least three instances in three Availability Zones. EP* is only for functions')
@allowed(['S1', 'S2', 'S3', 'P1V3', 'P2V3', 'P3V3', 'P1V3_AZ', 'P2V3_AZ', 'P3V3_AZ', 'EP1', 'EP2', 'EP3'])
param sku string = 'S1'

// https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/patterns-configuration-set#example
var skuConfigurationMap = {
  EP1: {
    name: 'EP1'
    tier: 'ElasticPremium'
    size: 'EP1'
    family: 'EP'
    capacity: 1
  }
  EP2: {
    name: 'EP2'
    tier: 'ElasticPremium'
    size: 'EP2'
    family: 'EP'
    capacity: 1
  }
  EP3: {
    name: 'EP3'
    tier: 'ElasticPremium'
    size: 'EP3'
    family: 'EP'
    capacity: 1
  }
  B1: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  B2: {
    name: 'B2'
    tier: 'Basic'
    size: 'B2'
    family: 'B'
    capacity: 1
  }
  B3: {
    name: 'B3'
    tier: 'Basic'
    size: 'B3'
    family: 'B'
    capacity: 1
  }
  S1: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  S2: {
    name: 'S2'
    tier: 'Standard'
    size: 'S2'
    family: 'S'
    capacity: 1
  }
  S3: {
    name: 'S3'
    tier: 'Standard'
    size: 'S3'
    family: 'S'
    capacity: 1
  }
  P1V3: {
    name: 'P1V3'
    tier: 'PremiumV2'
    size: 'P1V3'
    family: 'Pv3'
    capacity: 1
  }
  P1V3_AZ: {
    name: 'P1V3'
    tier: 'PremiumV2'
    size: 'P1V3'
    family: 'Pv3'
    capacity: 3
  }
  P2V3: {
    name: 'P2V3'
    tier: 'PremiumV2'
    size: 'P2V3'
    family: 'Pv3'
    capacity: 1
  }
  P2V3_AZ: {
    name: 'P2V3'
    tier: 'PremiumV2'
    size: 'P2V3'
    family: 'Pv3'
    capacity: 3
  }
  P3V3: {
    name: 'P3V3'
    tier: 'PremiumV2'
    size: 'P3V3'
    family: 'Pv3'
    capacity: 1
  }
  P3V3_AZ: {
    name: 'P3V3'
    tier: 'PremiumV2'
    size: 'P3V3'
    family: 'Pv3'
    capacity: 3
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: skuConfigurationMap[sku]
  kind: kind
  properties: {
    reserved: kind == 'linux'
  }
}

output id string = appServicePlan.id
output name string = appServicePlan.name
