// Parameters
@description('Name of your Event Grid')
param name string

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the Event Grid Namespace.')
param eventGridNamespaceName string = '${name}egn'

@description('Specifies the name of the Event Grid Namespace Topic Space.')
param eventGridNamespaceTopicSpaceName string = '${name}egnts'

@description('Specifies the name of the encoded certificate.')
param encodedCertificate string

resource eventGridNamespace 'Microsoft.EventGrid/namespaces@2024-06-01-preview' = {
  name: eventGridNamespaceName
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
    isZoneRedundant: true
    topicsConfiguration: {}
    topicSpacesConfiguration: {
      state: 'Enabled'
    }
  }
}

resource eventGridCaCertificate 'Microsoft.EventGrid/namespaces/caCertificates@2024-06-01-preview' = if (encodedCertificate != '') {
  parent: eventGridNamespace
  name: 'Intermediate01'
  properties: {
    encodedCertificate: encodedCertificate
  }
}

resource eventGridClient 'Microsoft.EventGrid/namespaces/clients@2024-06-01-preview' = {
  parent: eventGridNamespace
  name: 'sample_client'
  properties: {
    authenticationName: 'sample_client'
    state: 'Enabled'
    clientCertificateAuthentication: {
      validationScheme: 'SubjectMatchesAuthenticationName'
    }
    attributes: {
      room: '345'
      floor: 12
      deviceTypes: [
        'Fan'
        'Light'
      ]
    }
    description: 'This is a sample client'
  }
}

resource eventGridNamespaceTopicSpace 'Microsoft.EventGrid/namespaces/topicSpaces@2024-06-01-preview' = {
  parent: eventGridNamespace
  name: eventGridNamespaceTopicSpaceName
  properties: {
    description: 'This is a sample topic-space for Event Grid namespace'
    topicTemplates: [
      'sample/#'
    ]
  }
}

resource permissionBindingForPublisher 'Microsoft.EventGrid/namespaces/permissionBindings@2024-06-01-preview' = {
  name: 'samplesPub'
  parent: eventGridNamespace
  properties: {
    clientGroupName: '$all'
    description: 'A publisher permission binding for the namespace'
    permission: 'Publisher'
    topicSpaceName: eventGridNamespaceTopicSpace.name
  }
}

resource permissionBindingForSubscriber 'Microsoft.EventGrid/namespaces/permissionBindings@2024-06-01-preview' = {
  name: 'samplesSub'
  parent: eventGridNamespace
  properties: {
    clientGroupName: '$all'
    description: 'A subscriber permission binding for the namespace'
    permission: 'Subscriber'
    topicSpaceName: eventGridNamespaceTopicSpace.name
  }
}
