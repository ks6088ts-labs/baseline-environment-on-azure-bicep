using 'main.bicep'

param logAnalyticsEnabled = true
param logAnalyticsSku = 'PerGB2018'
param logAnalyticsRetentionInDays = 30
param keyVaultEnabled = true
param storageAccountEnabled = true
param cosmosDbEnabled = true
param apiManagementEnabled = true
param appServicePlanEnabled = true
param appServiceEnabled = true
param openAiEnabled = true
param openAiDeployments = [
  {
    name: 'text-embedding-ada-002'
    version: '2'
    capacity: 30
  }
  {
    name: 'gpt-35-turbo'
    version: '0613'
    capacity: 30
  }
]
param openAiPublicNetworkAccess = 'Enabled'
param cognitiveSearchEnabled = true
param containerRegistryEnabled = true
param iotHubEnabled = true
param virtualMachineEnabled = true
param virtualNetworkEnabled = true
param authenticationType = 'sshPublicKey'
param vmAdminUsername = 'azadmin'
param vmAdminPasswordOrKey = '<ssh-public-key>'
param tags = {
  scenario: 'example'
}
