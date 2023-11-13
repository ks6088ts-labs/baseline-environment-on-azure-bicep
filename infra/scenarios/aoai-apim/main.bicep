// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id)

@description('Specifies whether name resources are in CamelCase, UpperCamelCase, or KebabCase.')
@allowed([
  'CamelCase'
  'UpperCamelCase'
  'KebabCase'
])
param letterCaseType string = 'UpperCamelCase'

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the API Management.')
param apiManagementName string = letterCaseType == 'UpperCamelCase' ? 'apim${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Apim' : letterCaseType == 'CamelCase' ? 'apim${toLower(prefix)}Apim' : 'apim${toLower(prefix)}-apim'

@description('Specifies the location of the API Management.')
param apiManagementLocation string

@description('Specifies the resource model definition representing SKU.')
param apiManagementSku string

@description('Specifies the name of the Azure OpenAI resource.')
param openAiName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}OpenAi' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}OpenAi' : '${toLower(prefix)}-openai'

@description('Specifies the resource model definition representing SKU.')
param openAiSku object = {
  name: 'S0'
}

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = []

module apim '../../modules/apiManagement.bicep' = {
  name: 'apiManagement'
  params: {
    name: apiManagementName
    location: apiManagementLocation
    tags: tags
    sku: apiManagementSku
  }
}

module openAi '../../modules/openAi.bicep' = {
  name: 'openAi'
  params: {
    name: openAiName
    sku: openAiSku
    customSubDomainName: toLower(openAiName)
    deployments: openAiDeployments
    location: location
    tags: tags
  }
}
