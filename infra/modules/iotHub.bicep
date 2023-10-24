// Parameters
@description('Name of your Azure IoT Hub')
@minLength(3)
@maxLength(50)
param name string

@description('Specify the location of the resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('The SKU to use for the IoT Hub.')
@allowed([
  'B1'
  'B2'
  'B3'
  'F1'
  'S1'
  'S2'
  'S3'
])
param sku string = 'S1'

@description('Specifies the number of provisioned IoT Hub units. Restricted to 1 unit for the F1 SKU. Can be set up to maximum number allowed for subscription.')
@minValue(1)
@maxValue(200)
param capacityUnits int = 1

resource iotHub 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: name
  location: location
  tags: tags
  properties: {}
  sku: {
    name: sku
    capacity: capacityUnits
  }
}

// Outputs
output id string = iotHub.id
output name string = iotHub.name
