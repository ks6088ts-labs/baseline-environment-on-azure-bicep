// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id)

@description('Specifies whether name resources are in CamelCase, UpperCamelCase, or KebabCase.')
@allowed([
  'CamelCase'
  'UpperCamelCase'
  'KebabCase'
])
param letterCaseType string = 'UpperCamelCase'

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {
  IaC: 'Bicep'
}

@description('Specifies the name of the Log Analytics Workspace.')
param logAnalyticsWorkspaceName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Workspace' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Workspace' : '${toLower(prefix)}-workspace'

@description('Specify the pricing tier: PerGB2018 or legacy tiers (Free, Standalone, PerNode, Standard or Premium) which are not available to all customers.')
@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param logAnalyticsSku string = 'PerGB2018'

@description('Specifies the workspace data retention in days. -1 means Unlimited retention for the Unlimited Sku. 730 days is the maximum allowed for all other Skus.')
param logAnalyticsRetentionInDays int = 60

module workspace './modules/logAnalytics.bicep' = {
  name: 'workspace'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    sku: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
    tags: tags
  }
}
