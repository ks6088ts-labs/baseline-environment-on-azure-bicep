// Parameters
@description('Specifies the name prefix for all the Azure resources.')
@minLength(4)
@maxLength(10)
param prefix string = substring(uniqueString(resourceGroup().id, location), 0, 4)

@description('Specifies the location for all the Azure resources.')
param location string = resourceGroup().location

@description('Specifies the name of the Azure AI Services resource.')
param aiServicesName string = '${prefix}-ai-services'

@description('Specifies the resource model definition representing SKU.')
param aiServicesSku object = {
  name: 'S0'
}

@description('Specifies the identity of the Azure AI Services resource.')
param aiServicesIdentity object = {
  type: 'SystemAssigned'
}

@description('Specifies an optional subdomain name used for token-based authentication.')
param aiServicesCustomSubDomainName string = toLower(aiServicesName)

@description('Specifies whether disable the local authentication via API key.')
param aiServicesDisableLocalAuth bool = false

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param aiServicesPublicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = []

@description('Specifies the name of the Bing Search resource.')
param bingSearchName string = '${prefix}-bing-search'

@description('Specifies the resource model definition representing SKU.')
param bingSearchSku object = {
  name: 'S1'
}

@description('Specifies the resource tags for all the resoources.')
param tags object = {}

// Resources
module aiServices '../../modules/aiServices.bicep' = {
  name: 'aiServices'
  params: {
    name: aiServicesName
    location: location
    tags: tags
    sku: aiServicesSku
    identity: aiServicesIdentity
    customSubDomainName: aiServicesCustomSubDomainName
    disableLocalAuth: aiServicesDisableLocalAuth
    publicNetworkAccess: aiServicesPublicNetworkAccess
    deployments: openAiDeployments
    workspaceId: ''
  }
}

module bingSearch '../../modules/bingSearch.bicep' = {
  name: 'bingSearch'
  params: {
    name: bingSearchName
    location: 'global'
    tags: tags
    sku: bingSearchSku
  }
}

output deploymentInfo object = {
  subscriptionId: subscription().subscriptionId
  resourceGroupName: resourceGroup().name
  location: location
  aiServicesName: aiServices.outputs.name
  aiServicesEndpoint: aiServices.outputs.endpoint
}
