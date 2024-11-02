extension microsoftGraphV1_0

// Parameters
@description('Specifies the name prefix for all the Azure resources.')
@minLength(4)
@maxLength(10)
param prefix string = substring(uniqueString(resourceGroup().id, location), 0, 4)

@description('Specifies the location for all the Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags for all the resoources.')
param tags object = {}

@description('Specifies the groups to create.')
param groups array = []

resource exampleGroups 'Microsoft.Graph/groups@v1.0' = [
  for group in groups: {
    displayName: group.displayName
    mailEnabled: group.mailEnabled
    mailNickname: group.mailNickname
    securityEnabled: group.securityEnabled
    uniqueName: group.uniqueName
  }
]

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${prefix}-mi'
  location: location
  tags: tags
}
