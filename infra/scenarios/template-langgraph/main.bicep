// Common parameters
@description('Specifies the primary location of Azure resources.')
param location string = 'japaneast'

@description('Specifies the name prefix.')
param resourceToken string = uniqueString(resourceGroup().id, location)

@description('Specifies the resource tags.')
param tags object = {}

// Azure AI Foundry parameters
@description('Specifies the name of the Azure AI Foundry resource.')
param aiFoundryName string = 'aiFoundry-${resourceToken}'

@description('Specifies the name of the Azure AI Foundry project.')
param aiFoundryProjectName string = 'aiFoundryProject-${resourceToken}'

@description('Specifies the name of the model deployment.')
param aiFoundryModelDeployments array = [
  {
    name: 'gpt-4o'
    sku: {
      capacity: 1
      name: 'GlobalStandard'
    }
    model_name: 'gpt-4o'
  }
  {
    name: 'text-embedding-3-small'
    sku: {
      capacity: 1
      name: 'GlobalStandard'
    }
    model_name: 'text-embedding-3-small'
  }
]

// Azure AI Foundry resources
resource aiFoundry 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: aiFoundryName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  properties: {
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
    disableLocalAuth: false
    allowProjectManagement: true
    customSubDomainName: aiFoundryName
  }
}

resource aiFoundryProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: aiFoundry
  name: aiFoundryProjectName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

@batchSize(1)
resource aiFoundryDeployments 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = [
  for aiFoundryModelDeployment in aiFoundryModelDeployments: {
    parent: aiFoundry
    name: aiFoundryModelDeployment.name
    tags: tags
    sku: aiFoundryModelDeployment.sku
    properties: {
      model: {
        name: aiFoundryModelDeployment.model_name
        format: 'OpenAI'
      }
    }
  }
]
