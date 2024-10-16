using 'main.bicep'

param location = 'japaneast'

param openAiDeployments = [
  {
    model: {
      name: 'gpt-4o'
      version: '2024-05-13'
    }
    sku: {
      name: 'GlobalStandard'
      capacity: 10
    }
  }
  {
    model: {
      name: 'gpt-4o-mini'
      version: '2024-07-18'
    }
    sku: {
      name: 'GlobalStandard'
      capacity: 10
    }
  }
  {
    model: {
      name: 'text-embedding-3-small'
      version: '1'
    }
    sku: {
      name: 'Standard'
      capacity: 10
    }
  }
]

// param eventGridEncodedCertificate = ''

param tags = {
  scenario: 'workshop-azure-iot'
}
