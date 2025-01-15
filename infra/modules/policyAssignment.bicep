// Parameters
@description('Specifies the name of the virtual machine.')
param name string

@description('Specifies the policy definition id.')
param policyDefinitionId string

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: name
  scope: resourceGroup()
  properties: {
    policyDefinitionId: policyDefinitionId
    description: '${name} ${policyDefinitionId}'
  }
}

output id string = policyAssignment.id
output name string = policyAssignment.name
