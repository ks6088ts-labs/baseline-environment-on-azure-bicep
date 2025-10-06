using 'main.bicep'

param location = 'japaneast'
param aiFoundryLocation = 'japaneast'

param tags = {
  owner: 'ks6088ts'
  scenario: 'template-langgraph'
  SecurityControl: 'Ignore'
  CostControl: 'Ignore'
}

// Flags for deploying resources
param aiFoundryEnabled = true
param cosmosDbEnabled = true
param aiSearchEnabled = false
param appServiceEnabled = false

param aiFoundryModelDeployments = [
  {
    name: 'gpt-5'
    sku: {
      capacity: 1000
      name: 'GlobalStandard'
    }
    model: {
      name: 'gpt-5'
      format: 'OpenAI'
      version: '2025-08-07'
    }
  }
  {
    name: 'gpt-4o'
    sku: {
      capacity: 450
      name: 'GlobalStandard'
    }
    model: {
      name: 'gpt-4o'
      format: 'OpenAI'
      version: '2024-08-06'
    }
  }
  {
    name: 'text-embedding-3-large'
    sku: {
      capacity: 1000
      name: 'GlobalStandard'
    }
    model: {
      name: 'text-embedding-3-large'
      format: 'OpenAI'
      version: '1'
    }
  }
  {
    name: 'text-embedding-3-small'
    sku: {
      capacity: 1000
      name: 'GlobalStandard'
    }
    model: {
      name: 'text-embedding-3-small'
      format: 'OpenAI'
      version: '1'
    }
  }
]
