// Parameters
@description('Specifies the name of the Azure Policy Assignment resource.')
param name string

@description('Specifies the policy definition id.')
param policyDefinitionId string

module policyAssignment '../../modules/policyAssignment.bicep' = {
  name: 'policyAssignment'
  params: {
    name: name
    policyDefinitionId: policyDefinitionId
  }
}
