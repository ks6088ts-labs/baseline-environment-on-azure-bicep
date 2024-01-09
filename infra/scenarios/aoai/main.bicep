// Parameters
@description('Specifies the primary location of Azure resources.')
param location string

@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id, location)

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the Azure Computer Vision resource')
param openAiName string = '${prefix}openai'

@description('Specifies the name of the Azure Computer Vision resource')
param computerVisionName string = '${prefix}computervision'

@description('Specifies the OpenAI SKU.')
param openAiSkuName string = 'S0'

@description('Specifies the Computer Vision SKU.')
param computerVisionSkuName string = 'S1'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = []

module computerVision 'br/public:ai/cognitiveservices:1.1.1' = {
  name: 'computerVision'
  params: {
    name: computerVisionName
    location: location
    tags: tags
    skuName: computerVisionSkuName
    kind: 'ComputerVision'
    customSubDomainName: toLower(computerVisionName)
  }
}

module openAI 'br/public:ai/cognitiveservices:1.1.1' = {
  name: 'openai'
  params: {
    name: openAiName
    location: location
    tags: tags
    skuName: openAiSkuName
    kind: 'OpenAI'
    deployments: openAiDeployments
    customSubDomainName: toLower(openAiName)
  }
}
