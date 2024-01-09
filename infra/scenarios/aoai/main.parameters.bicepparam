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
    name: 'gpt-35-turbo'
    sku: {
      name: 'Standard'
      capacity: 1
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: 'gpt-35-turbo'
        version: '1106'
      }
      raiPolicyName: 'Microsoft.Default'
    }
  }
  {
    name: 'gpt-4'
    sku: {
      name: 'Standard'
      capacity: 1
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: 'gpt-4'
        version: 'vision-preview'
      }
      raiPolicyName: 'Microsoft.Default'
    }
  }
]

param tags = {
  scenario: 'aoai'
}
