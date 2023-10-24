// Parameters
@description('Specifies the name of the storage account.')
param name string

@description('Specifies whether to create containers.')
param createContainers bool = true

@description('Specifies an array of containers to create.')
param containerNames array = []

@description('Specifies the name of a Key Vault where to store secrets.')
param keyVaultName string = '${name}-kv'

@description('Specifies the resource id of the Log Analytics workspace.')
param workspaceId string = ''

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

// Variables
var logAnalyticsEnabled = !empty(workspaceId)
var diagnosticSettingsName = '${name}StorageAccountDiagnosticSettings'
var logCategories = [
  'StorageRead'
  'StorageWrite'
  'StorageDelete'
]
var metricCategories = [
  'Transaction'
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
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  // Containers live inside of a blob service
  resource blobService 'blobServices' = {
    name: 'default'

    // Creating containers with provided names if contition is true
    resource containers 'containers' = [for containerName in containerNames: if (createContainers) {
      name: containerName
      properties: {
        publicAccess: 'None'
      }
    }]
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (logAnalyticsEnabled) {
  name: diagnosticSettingsName
  scope: storageAccount::blobService
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource storageAccountNameSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'DataProtection--BlobStorage--AccountName'
  properties: {
    value: storageAccount.name
  }
}

resource storageAccountConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'DataProtection--BlobStorage--ConnectionString'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
  }
}

resource storageAccountUseAzureCredentialSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  parent: keyVault
  name: 'DataProtection--BlobStorage--UseAzureCredential'
  properties: {
    value: 'true'
  }
}

// Outputs
output id string = storageAccount.id
output name string = storageAccount.name
