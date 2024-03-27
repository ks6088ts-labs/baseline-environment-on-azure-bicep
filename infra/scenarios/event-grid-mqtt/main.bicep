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

@description('Specifies the principal ID.')
param principalId string

@description('Specifies whether creating the Event Hub resource or not.')
param eventHubEnabled bool = false

@description('Specifies the name of the Event Hub Namespace.')
param eventHubNamespaceName string = '${prefix}ehn'

@description('Specifies the name of the Event Hub.')
param eventHubName string = '${prefix}eh'

// EventGrid Data Sender: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/integration#eventgrid-data-sender
var eventGridDataSenderRoleDefinitionId = 'd5a91429-5739-47e2-a06b-3470a27159e7'

resource eventGridNamesapce 'Microsoft.EventGrid/namespaces@2023-12-15-preview' = {
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

resource eventGridTopic 'Microsoft.EventGrid/topics@2023-12-15-preview' = {
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

resource eventGridClient1 'Microsoft.EventGrid/namespaces/clients@2023-12-15-preview' = {
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

resource eventGridClient2 'Microsoft.EventGrid/namespaces/clients@2023-12-15-preview' = {
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

resource eventGridNamesapceTopicSpace 'Microsoft.EventGrid/namespaces/topicSpaces@2023-12-15-preview' = {
  parent: eventGridNamesapce
  name: eventGridNamesapceTopicSpaceName
  properties: {
    description: 'This is a sample topic-space for Event Grid namespace'
    topicTemplates: [
      'contosotopics/topic1'
    ]
  }
}

resource permissionBindingForPublisher 'Microsoft.EventGrid/namespaces/permissionBindings@2023-12-15-preview' = {
  name: 'contosopublisherbinding'
  parent: eventGridNamesapce
  properties: {
    clientGroupName: '$all'
    description: 'A publisher permission binding for the namespace'
    permission: 'Publisher'
    topicSpaceName: eventGridNamesapceTopicSpace.name
  }
}

resource permissionBindingForSubscriber 'Microsoft.EventGrid/namespaces/permissionBindings@2023-06-01-preview' = {
  name: 'contososubscriberbinding'
  parent: eventGridNamesapce
  properties: {
    clientGroupName: '$all'
    description: 'A subscriber permission binding for the namespace'
    permission: 'Subscriber'
    topicSpaceName: eventGridNamesapceTopicSpace.name
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, eventGridDataSenderRoleDefinitionId, eventGridTopic.id)
  scope: eventGridTopic
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', eventGridDataSenderRoleDefinitionId)
    principalId: principalId
  }
}

// EventHub
resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' =
  if (eventHubEnabled) {
    name: eventHubNamespaceName
    location: location
    tags: tags
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
  }

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' =
  if (eventHubEnabled) {
    parent: eventHubNamespace
    name: eventHubName
    properties: {
      messageRetentionInDays: 1
      partitionCount: 1
    }
  }

resource eventSubscription 'Microsoft.EventGrid/eventSubscriptions@2023-12-15-preview' =
  if (eventHubEnabled) {
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
