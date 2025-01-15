using 'main.bicep'

// New Azure API Management tiers (preview): https://learn.microsoft.com/en-us/azure/api-management/v2-service-tiers-overview
param apiManagementLocation = 'eastasia'
param apiManagementSku = 'StandardV2'

param openAiDeployments = [
  {
    name: 'text-embedding-ada-002'
    version: '2'
    capacity: 30
  }
  {
    name: 'gpt-4o'
    version: '2024-11-20'
    capacity: 30
  }
]

param tags = {
  scenario: 'aoai-apim'
}
