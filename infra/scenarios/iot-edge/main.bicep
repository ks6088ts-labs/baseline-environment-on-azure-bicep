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

@description('Name of your Azure Container Registry')
@minLength(5)
@maxLength(50)
param containerRegistryName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Acr' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Acr' : '${toLower(prefix)}-acr'

@description('Enable admin user that have push / pull permission to the registry.')
param containerRegistryAdminUserEnabled bool = false

@description('Tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param containerRegistrySku string = 'Standard'

@description('Name of your Azure IoT Hub')
@minLength(5)
@maxLength(50)
param iotHubName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}IotHub' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}IotHub' : '${toLower(prefix)}-iothub'

@description('The SKU to use for the IoT Hub.')
@allowed([
  'B1'
  'B2'
  'B3'
  'F1'
  'S1'
  'S2'
  'S3'
])
param iotHubSku string = 'S1'

@description('Name of your Azure Virtual Network')
param virtualNetworkName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}VNet' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}VNet' : '${toLower(prefix)}-vnet'

@description('Specifies whether creating the Azure Bastion Host resource or not.')
param bastionHostEnabled bool = false

@description('Specifies whether creating the Azure NAT Gateway resource or not.')
param natGatewayEnabled bool = false

@description('Specifies the name of the administrator account of the virtual machine.')
param vmAdminUsername string

@description('Specifies the SSH Key or password for the virtual machine. SSH key is recommended.')
@secure()
param vmAdminPasswordOrKey string

@description('Specifies the type of authentication when accessing the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

module workspace '../../modules/logAnalytics.bicep' = {
  name: 'workspace'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    sku: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
    tags: tags
  }
}

module containerRegistry '../../modules/containerRegistry.bicep' = {
  name: 'containerRegistry'
  params: {
    name: containerRegistryName
    sku: containerRegistrySku
    adminUserEnabled: containerRegistryAdminUserEnabled
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

module iotHub '../../modules/iotHub.bicep' = {
  name: 'iotHub'
  params: {
    name: iotHubName
    sku: iotHubSku
    location: location
    tags: tags
  }
}

module network '../../modules/virtualNetwork.bicep' = {
  name: 'virtualNetwork'
  params: {
    virtualNetworkName: virtualNetworkName
    bastionHostName: '${prefix}-bastion'
    bastionHostEnabled: bastionHostEnabled
    natGatewayName: '${prefix}-natgw'
    natGatewayEnabled: natGatewayEnabled
    location: location
    tags: tags
  }
}

module virtualMachine '../../modules/virtualMachine.bicep' = {
  name: 'virtualMachine'
  params: {
    vmSubnetId: network.outputs.vmSubnetId
    vmAdminPasswordOrKey: vmAdminPasswordOrKey
    vmAdminUsername: vmAdminUsername
    authenticationType: authenticationType
    managedIdentityName: letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}AzureMonitorAgentManagedIdentity' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}AzureMonitorAgentManagedIdentity' : '${toLower(prefix)}-azure-monitor-agent-managed-identity'
    location: location
    tags: tags
  }
}
