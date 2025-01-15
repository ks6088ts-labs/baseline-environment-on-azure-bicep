using 'main.bicep'

param location = 'westus'

param openAiDeployments = [
  {
    name: 'text-embedding-ada-002'
    sku: {
      name: 'Standard'
      capacity: 1
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: 'text-embedding-ada-002'
        version: '2'
      }
      raiPolicyName: 'Microsoft.Default'
    }
  }
  {
    name: 'gpt-4o'
    sku: {
      name: 'GlobalStandard'
      capacity: 1
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: 'gpt-4o'
        version: '2024-11-20'
      }
      raiPolicyName: 'Microsoft.Default'
    }
  }
]

param tags = {
  scenario: 'aoai'
}
