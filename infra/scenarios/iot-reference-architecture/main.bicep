// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id)

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Stream Analytics Job Name, can contain alphanumeric characters and hypen and must be 3-63 characters long')
@minLength(3)
@maxLength(63)
param streamAnalyticsJobName string = '${prefix}saj'

@description('You can choose the number of Streaming Units, ranging from 3, 7, 10, 20, 30, in multiples of 10, and continuing up to 660.')
@minValue(3)
@maxValue(660)
param numberOfStreamingUnits int = 3

resource streamingJob 'Microsoft.StreamAnalytics/streamingjobs@2021-10-01-preview' = {
  name: streamAnalyticsJobName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'StandardV2'
    }
    outputErrorPolicy: 'Stop'
    eventsOutOfOrderPolicy: 'Adjust'
    eventsOutOfOrderMaxDelayInSeconds: 0
    eventsLateArrivalMaxDelayInSeconds: 5
    dataLocale: 'en-US'
    transformation: {
      name: 'Transformation'
      properties: {
        streamingUnits: numberOfStreamingUnits
        query: 'SELECT\r\n    *\r\nINTO\r\n    [YourOutputAlias]\r\nFROM\r\n    [YourInputAlias]'
      }
    }
  }
}
