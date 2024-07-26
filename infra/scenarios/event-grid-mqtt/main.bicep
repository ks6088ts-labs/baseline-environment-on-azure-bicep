// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id)

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the Event Grid Namespace.')
param eventGridNamesapceName string = '${prefix}egn'

@description('Specifies the name of the Event Grid Topic')
param eventGridTopicName string = '${prefix}egt'

@description('Specifies the name of the Event Grid Client.')
param eventGridClientThumbprint1 string

@description('Specifies the name of the Event Grid Client.')
param eventGridClientThumbprint2 string

@description('Specifies the name of the Event Grid Namespace Topic Space.')
param eventGridNamesapceTopicSpaceName string = 'ContosoTopicSpace'

@description('Specifies whether creating the Event Hub resource or not.')
param eventHubEnabled bool = false

@description('Specifies the name of the Event Hub Namespace.')
param eventHubNamespaceName string = '${prefix}ehn'

@description('Specifies the name of the Event Hub.')
param eventHubName string = '${prefix}eh'

@description('Specifies whether to enable role assignment or not.')
param enableRoleAssignment bool = false

// EventGrid Data Sender: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/integration#eventgrid-data-sender
var eventGridDataSenderRoleDefinitionId = 'd5a91429-5739-47e2-a06b-3470a27159e7'

resource eventGridNamesapce 'Microsoft.EventGrid/namespaces@2024-06-01-preview' = {
  name: eventGridNamesapceName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    topicSpacesConfiguration: {
      state: 'Enabled'
      routeTopicResourceId: eventGridTopic.id
    }
  }
}

resource eventGridTopic 'Microsoft.EventGrid/topics@2024-06-01-preview' = {
  name: eventGridTopicName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
  properties: {
    inputSchema: 'CloudEventSchemaV1_0'
  }
}

resource eventGridClient1 'Microsoft.EventGrid/namespaces/clients@2024-06-01-preview' = {
  parent: eventGridNamesapce
  name: 'client1'
  properties: {
    authenticationName: 'client1-authn-ID'
    clientCertificateAuthentication: {
      validationScheme: 'ThumbprintMatch'
      allowedThumbprints: [
        eventGridClientThumbprint1
      ]
    }
    attributes: {
      room: '345'
      floor: 12
      deviceTypes: [
        'Fan'
        'Light'
      ]
    }
    description: 'client1 description'
    state: 'Enabled'
  }
}

resource eventGridClient2 'Microsoft.EventGrid/namespaces/clients@2024-06-01-preview' = {
  parent: eventGridNamesapce
  name: 'client2'
  properties: {
    authenticationName: 'client2-authn-ID'
    clientCertificateAuthentication: {
      validationScheme: 'ThumbprintMatch'
      allowedThumbprints: [
        eventGridClientThumbprint2
      ]
    }
    attributes: {
      room: '678'
      floor: 12
      deviceTypes: [
        'Fan'
        'Light'
      ]
    }
    description: 'client2 description'
    state: 'Enabled'
  }
}

resource eventGridNamesapceTopicSpace 'Microsoft.EventGrid/namespaces/topicSpaces@2024-06-01-preview' = {
  parent: eventGridNamesapce
  name: eventGridNamesapceTopicSpaceName
  properties: {
    description: 'This is a sample topic-space for Event Grid namespace'
    topicTemplates: [
      'contosotopics/topic1'
    ]
  }
}

resource permissionBindingForPublisher 'Microsoft.EventGrid/namespaces/permissionBindings@2024-06-01-preview' = {
  name: 'contosopublisherbinding'
  parent: eventGridNamesapce
  properties: {
    clientGroupName: '$all'
    description: 'A publisher permission binding for the namespace'
    permission: 'Publisher'
    topicSpaceName: eventGridNamesapceTopicSpace.name
  }
}

resource permissionBindingForSubscriber 'Microsoft.EventGrid/namespaces/permissionBindings@2024-06-01-preview' = {
  name: 'contososubscriberbinding'
  parent: eventGridNamesapce
  properties: {
    clientGroupName: '$all'
    description: 'A subscriber permission binding for the namespace'
    permission: 'Subscriber'
    topicSpaceName: eventGridNamesapceTopicSpace.name
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableRoleAssignment) {
  name: guid(eventGridNamesapce.id, eventGridDataSenderRoleDefinitionId, eventGridTopic.id)
  scope: eventGridTopic
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', eventGridDataSenderRoleDefinitionId)
    principalId: eventGridNamesapce.identity.principalId
  }
}

// EventHub
resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = if (eventHubEnabled) {
  name: eventHubNamespaceName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = if (eventHubEnabled) {
  parent: eventHubNamespace
  name: eventHubName
  properties: {
    messageRetentionInDays: 1
    partitionCount: 1
  }
}

resource eventSubscription 'Microsoft.EventGrid/eventSubscriptions@2022-06-15' = if (eventHubEnabled) {
  name: 'contosoEventSubscription'
  scope: eventGridTopic
  properties: {
    destination: {
      endpointType: 'EventHub'
      properties: {
        resourceId: eventHub.id
      }
    }
    eventDeliverySchema: 'CloudEventSchemaV1_0'
  }
}

// Functions
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${prefix}-logworkspace'
  location: location
  tags: tags
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${prefix}-appinsights'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}

var validStoragePrefix = take(replace(prefix, '-', ''), 17)
var functionAppName = '${prefix}-function-app'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: '${validStoragePrefix}storage'
  location: location
  kind: 'StorageV2'
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${prefix}-plan'
  location: location
  tags: tags
  kind: 'functionapp'
  properties: {
    reserved: true
  }
  sku: {
    name: 'Y1'
  }
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: functionAppName
  location: location
  tags: union(tags, {
    'azd-service-name': 'api'
  })
  kind: 'functionapp,linux'
  properties: {
    httpsOnly: true
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: false
    siteConfig: {
      minTlsVersion: '1.2'
      linuxFxVersion: 'Python|3.11'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'ENABLE_ORYX_BUILD'
          value: 'true'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
      ]
    }
  }
}
