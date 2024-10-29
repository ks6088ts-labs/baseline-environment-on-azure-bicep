// Parameters
@description('Name of your Event Hub')
param name string

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the SKU of the Event Hub Namespace.')
param sku object = {
  name: 'Standard'
  tier: 'Standard'
  capacity: 1
}

@description('Specifies the name of the Event Hub Namespace.')
param eventHubNamespaceName string = '${name}ns'

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-05-01-preview' = {
  name: eventHubNamespaceName
  location: location
  tags: tags
  sku: sku
  properties: {
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-05-01-preview' = {
  parent: eventHubNamespace
  name: name
  properties: {
    messageRetentionInDays: 7
    partitionCount: 1
  }
}
