// Parameters
@description('Specifies the name of the Azure OpenAI resource.')
param name string

@description('Specifies the resource model definition representing SKU.')
param sku object = {
  name: 'S0'
}

@description('Specifies the identity of the OpenAI resource.')
param identity object = {
  type: 'SystemAssigned'
}

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies an optional subdomain name used for token-based authentication.')
param customSubDomainName string = ''

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param deployments array = []

@description('Specifies the workspace id of the Log Analytics used to monitor the Application Gateway.')
param workspaceId string = ''

// Variables
var logAnalyticsEnabled = !empty(workspaceId)
var diagnosticSettingsName = '${name}diagnosticSettings'
var openAiLogCategories = [
  'Audit'
  'RequestResponse'
  'Trace'
]
var openAiMetricCategories = [
  'AllMetrics'
]
var openAiLogs = [for category in openAiLogCategories: {
  category: category
  enabled: true
}]
var openAiMetrics = [for category in openAiMetricCategories: {
  category: category
  enabled: true
}]

// Resources
resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  sku: sku
  kind: 'OpenAI'
  identity: identity
  tags: tags
  properties: {
    customSubDomainName: customSubDomainName
    publicNetworkAccess: publicNetworkAccess
  }
}

resource model 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for deployment in deployments: {
  name: deployment.name
  parent: openAi
  properties: {
    model: {
      format: 'OpenAI'
      name: deployment.name
      version: deployment.version
    }
    raiPolicyName: contains(deployment, 'raiPolicyName') ? deployment.raiPolicyName : null
  }
  sku: contains(deployment, 'sku') ? deployment.sku : {
    name: 'Standard'
    capacity: deployment.capacity
  }
}]

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (logAnalyticsEnabled) {
  name: diagnosticSettingsName
  scope: openAi
  properties: {
    workspaceId: workspaceId
    logs: openAiLogs
    metrics: openAiMetrics
  }
}

// Outputs
output id string = openAi.id
output name string = openAi.name
output endpoint string = openAi.properties.endpoint
