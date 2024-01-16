// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id, location)

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specify the name of the Iot hub.')
param iotHubName string = '${prefix}iothub'

@description('Specify the name of the provisioning service.')
param provisioningServiceName string = '${prefix}dps'

@description('The SKU to use for the IoT Hub.')
param skuName string = 'S1'

@description('The number of IoT Hub units.')
param skuUnits int = 1

var iotHubKey = 'iothubowner'
var iotHubLocations = [ 'eastus', 'centralus', 'westus' ]

// deploy module n times
resource iotHubs 'Microsoft.Devices/IotHubs@2023-06-30' = [for iotHubLocation in iotHubLocations: {
  name: '${iotHubName}-${iotHubLocation}'
  location: iotHubLocation
  tags: tags
  sku: {
    name: skuName
    capacity: skuUnits
  }
  properties: {}
}]

resource provisioningService 'Microsoft.Devices/provisioningServices@2022-12-12' = {
  name: provisioningServiceName
  location: location
  tags: tags
  sku: {
    name: skuName
    capacity: skuUnits
  }
  properties: {
    allocationPolicy: 'GeoLatency'
    iotHubs: [for (iotHub, i) in iotHubLocations: {
      connectionString: 'HostName=${iotHubs[i].properties.hostName};SharedAccessKeyName=${iotHubKey};SharedAccessKey=${iotHubs[i].listkeys().value[0].primaryKey}'
      location: iotHubs[i].location
    }]
  }
}
