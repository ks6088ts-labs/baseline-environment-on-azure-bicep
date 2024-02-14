using 'main.bicep'

param vmAdminUsername = 'azureuser'
param vmAdminPasswordOrKey = 'helloworld123!'

param tags = {
  scenario: 'sandbox-bastion'
}
