// Parameters
@description('Specifies the name of the Azure AI Services account.')
param name string

@description('Specifies the location.')
param location string

@description('Specifies the resource model definition representing SKU.')
param sku object

@description('Specifies the resource tags.')
param tags object

// Resources
// https://github.com/Azure/bicep/issues/5286
#disable-next-line BCP081
resource bingSearchAccount 'Microsoft.Bing/accounts@2020-06-10' = {
  name: name
  location: location
  sku: sku
  tags: tags
  kind: 'Bing.Search.v7'
}

// Outputs
output id string = bingSearchAccount.id
output name string = bingSearchAccount.name
