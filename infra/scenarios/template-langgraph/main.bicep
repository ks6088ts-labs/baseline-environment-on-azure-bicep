// Common parameters
@description('Specifies the primary location of Azure resources.')
param location string = 'japaneast'

@description('Specifies the name prefix.')
param resourceToken string = uniqueString(resourceGroup().id, location, aiFoundryLocation)

@description('Specifies the resource tags.')
param tags object = {}

// Azure AI Foundry parameters
@description('Specifies whether to enable Azure AI Foundry resources.')
param aiFoundryEnabled bool = false

@description('Specifies the name of the Azure AI Foundry resource.')
param aiFoundryName string = 'aiFoundry-${resourceToken}'

@description('Specifies the location of the Azure AI Foundry resource.')
param aiFoundryLocation string = 'japaneast'

@description('Specifies the name of the Azure AI Foundry project.')
param aiFoundryProjectName string = 'aiFoundryProject-${resourceToken}'

@description('Specifies the name of the model deployment.')
param aiFoundryModelDeployments array = [
  {
    name: 'gpt-4o'
    sku: {
      capacity: 450
      name: 'GlobalStandard'
    }
    model: {
      name: 'gpt-4o'
      format: 'OpenAI'
      version: '2024-08-06'
    }
  }
  // add more model deployments here
]

// Azure Cosmos DB parameters
@description('Specifies whether to enable Azure Cosmos DB resources.')
param cosmosDbEnabled bool = false

@description('Specifies the name of the Cosmos DB account.')
param cosmosDbAccountName string = 'cosmosdb-${resourceToken}'

@description('Specifies the name of the Cosmos DB database.')
param cosmosDbDatabaseName string = 'template_langgraph'

@description('Specifies the name of the Cosmos DB container.')
param cosmosDbContainerName string = 'kabuto'

// Azure AI Search parameters
@description('Specifies whether to enable Azure AI Search resources.')
param aiSearchEnabled bool = false

@description('Specifies the name of the Azure AI Search resource.')
param aiSearchName string = toLower('aiSearch${resourceToken}')

@description('The pricing tier of the search service you want to create (for example, basic or standard).')
param aiSearchSku string = 'standard'

// Azure App Service parameters
@description('Specifies whether to enable Azure App Service resources.')
param appServiceEnabled bool = false

@description('Specifies the name of the Azure App Service plan.')
param appServicePlanName string = 'appServicePlan-${resourceToken}'

@description('Specifies the name of the Azure App Service.')
param appServiceName string = 'appService-${resourceToken}'

@description('Specifies the Docker image for the Azure App Service.')
param appServiceDockerImage string = 'ks6088ts/template-langgraph:latest'

// Azure AI Foundry resources
resource aiFoundry 'Microsoft.CognitiveServices/accounts@2025-07-01-preview' = if (aiFoundryEnabled) {
  name: aiFoundryName
  location: aiFoundryLocation
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

resource aiFoundryProject 'Microsoft.CognitiveServices/accounts/projects@2025-07-01-preview' = if (aiFoundryEnabled) {
  parent: aiFoundry
  name: aiFoundryProjectName
  location: aiFoundryLocation
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

@batchSize(1)
resource aiFoundryDeployments 'Microsoft.CognitiveServices/accounts/deployments@2025-07-01-preview' = [
  for aiFoundryModelDeployment in aiFoundryModelDeployments: if (aiFoundryEnabled) {
    parent: aiFoundry
    name: aiFoundryModelDeployment.name
    tags: tags
    sku: aiFoundryModelDeployment.sku
    properties: {
      model: aiFoundryModelDeployment.model
    }
  }
]

// Azure Cosmos DB resources
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2025-05-01-preview' = if (cosmosDbEnabled) {
  name: cosmosDbAccountName
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    capabilities: [
      { name: 'EnableNoSQLVectorSearch' }
    ]
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2025-05-01-preview' = if (cosmosDbEnabled) {
  parent: cosmosDbAccount
  name: cosmosDbDatabaseName
  location: location
  tags: tags
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
    options: {
      throughput: 400
    }
  }
}

resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-05-01-preview' = if (cosmosDbEnabled) {
  parent: cosmosDbDatabase
  name: cosmosDbContainerName
  location: location
  tags: tags
  properties: {
    resource: {
      id: cosmosDbContainerName
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
      }
    }
  }
}

// Azure AI Search resources
resource aiSearch 'Microsoft.Search/searchServices@2025-10-01-preview' = if (aiSearchEnabled) {
  name: aiSearchName
  location: location
  sku: {
    name: aiSearchSku
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
  }
}

// Azure App Service resources
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = if (appServiceEnabled) {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: 'B1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2024-11-01' = if (appServiceEnabled) {
  name: appServiceName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${appServiceDockerImage}'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '8000'
        }
      ]
    }
  }
}

// Outputs
output resourceGroup object = {
  id: resourceGroup().id
  name: resourceGroup().name
  location: resourceGroup().location
}
