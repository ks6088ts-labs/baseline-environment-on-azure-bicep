// Parameters
@description('Name of your API Management service.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of your organization for use in the developer portal and e-mail notifications.')
param publisherName string = 'Contoso'

@description('Specifies the e-mail address to receive all system notifications.')
param publisherEmail string = 'noreply@microsoft.com'

@description('The pricing tier of this API Management service')
@allowed([
  'Basic'
  'Consumption'
  'Developer'
  'Isolated'
  'Premium'
  'Standard'
])
param sku string = 'Consumption'

resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: ((sku == 'Consumption') ? 0 : 1)
  }
  properties: {
    publisherName: publisherName
    publisherEmail: publisherEmail
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Outputs
output id string = apim.id
output name string = apim.name
