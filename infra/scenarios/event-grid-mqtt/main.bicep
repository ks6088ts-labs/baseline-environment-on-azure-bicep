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

@description('Specifies the name of the Event Hub Namespace.')
param eventHubNamespaceName string = '${prefix}ehn'

@description('Specifies the name of the Event Hub.')
param eventHubName string = '${prefix}eh'

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
    // Enable MQTT broker
    topicSpacesConfiguration: {
      state: 'Enabled'
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

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  parent: eventHubNamespace
  name: eventHubName
  properties: {
    messageRetentionInDays: 1
    partitionCount: 1
  }
}
