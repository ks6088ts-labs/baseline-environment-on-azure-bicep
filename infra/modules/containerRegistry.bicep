// Parameters
@description('Name of your Azure Container Registry')
param name string

@description('Enable admin user that have push / pull permission to the registry.')
param adminUserEnabled bool = false

@description('Tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string = ''

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

// Variables
var logAnalyticsEnabled = !empty(workspaceId)
var diagnosticSettingsName = '${name}ContainerRegistryDiagnosticSettings'
var logCategories = [
  'ContainerRegistryRepositoryEvents'
  'ContainerRegistryLoginEvents'
]
var metricCategories = [
  'AllMetrics'
]
var logs = [for category in logCategories: {
  category: category
  enabled: true
}]
var metrics = [for category in metricCategories: {
  category: category
  enabled: true
}]

// Resources
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-08-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (logAnalyticsEnabled) {
  name: diagnosticSettingsName
  scope: containerRegistry
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

// Outputs
output id string = containerRegistry.id
output name string = containerRegistry.name
