using 'main.bicep'

param location = 'japaneast'

param groups = [
  {
    displayName: 'exampleGroup1'
    mailEnabled: false
    mailNickname: 'exampleGroup1'
    securityEnabled: true
    uniqueName: 'exampleGroup1'
  }
  {
    displayName: 'exampleGroup2'
    mailEnabled: false
    mailNickname: 'exampleGroup2'
    securityEnabled: true
    uniqueName: 'exampleGroup2'
  }
]

param tags = {
  scenario: 'manage-microsoft-entra-id'
}
