// Parameters
@description('Specifies the primary location of Azure resources.')
param location string

@description('Specifies the name prefix.')
param resourceToken string = uniqueString(resourceGroup().id, location)

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the Azure AI Foundry resource.')
param aiFoundryName string = 'aiFoundry-${resourceToken}'

@description('Specifies the name of the Azure AI Foundry project.')
param aiFoundryProjectName string = 'aiFoundryProject-${resourceToken}'

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
    allowProjectManagement: true
    customSubDomainName: aiFoundryName
    disableLocalAuth: false
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

resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  parent: aiFoundry
  name: 'gpt-4o'
  tags: tags
  sku: {
    capacity: 1
    name: 'GlobalStandard'
  }
  properties: {
    model: {
      name: 'gpt-4o'
      format: 'OpenAI'
    }
  }
}
