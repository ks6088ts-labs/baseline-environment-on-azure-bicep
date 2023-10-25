using 'main.bicep'

param logAnalyticsSku = 'PerGB2018'
param logAnalyticsRetentionInDays = 30
param containerRegistryAdminUserEnabled = true
param authenticationType = 'sshPublicKey'
param vmAdminUsername = 'azadmin'
param vmAdminPasswordOrKey = '<ssh-public-key>'
param tags = {
  scenario: 'iot-edge'
}
