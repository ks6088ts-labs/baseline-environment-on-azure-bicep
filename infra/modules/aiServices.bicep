// Parameters
@description('Specifies the name of the Azure AI Services account.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource model definition representing SKU.')
param sku object = {
  name: 'S0'
}

@description('Specifies the identity of the aiServices resource.')
param identity object = {
  type: 'SystemAssigned'
}

@description('Specifies the resource tags.')
param tags object

@description('Specifies an optional subdomain name used for token-based authentication.')
param customSubDomainName string = ''

@description('Specifies whether disable the local authentication via API key.')
param disableLocalAuth bool = true

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param deployments array = []

@description('Specifies the workspace id of the Log Analytics used to monitor the Application Gateway.')
param workspaceId string

// Variables
var diagnosticSettingsName = 'diagnosticSettings'
var aiServicesLogCategories = [
  'Audit'
  'RequestResponse'
  'Trace'
]
var aiServicesMetricCategories = [
  'AllMetrics'
]
var aiServicesLogs = [
  for category in aiServicesLogCategories: {
    category: category
    enabled: true
  }
]
var aiServicesMetrics = [
  for category in aiServicesMetricCategories: {
    category: category
    enabled: true
  }
]

// Resources
resource aiServices 'Microsoft.CognitiveServices/accounts@2024-06-01-preview' = {
  name: name
  location: location
  sku: sku
  kind: 'AIServices'
  identity: identity
  tags: tags
  properties: {
    customSubDomainName: customSubDomainName
    disableLocalAuth: disableLocalAuth
    publicNetworkAccess: publicNetworkAccess
  }
}

@batchSize(1)
resource model 'Microsoft.CognitiveServices/accounts/deployments@2024-06-01-preview' = [
  for deployment in deployments: {
    name: deployment.model.name
    parent: aiServices
    sku: {
      capacity: deployment.sku.capacity ?? 100
      name: empty(deployment.sku.name) ? 'Standard' : deployment.sku.name
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: deployment.model.name
        version: deployment.model.version
      }
    }
  }
]

resource aiServicesDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (workspaceId != '') {
  name: diagnosticSettingsName
  scope: aiServices
  properties: {
    workspaceId: workspaceId
    logs: aiServicesLogs
    metrics: aiServicesMetrics
  }
}

// Outputs
output id string = aiServices.id
output name string = aiServices.name
output endpoint string = aiServices.properties.endpoint
output openAiEndpoint string = aiServices.properties.endpoints['OpenAI Language Model Instance API']
output principalId string = aiServices.identity.principalId
