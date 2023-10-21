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

@description('Specifies whether creating the Azure Key Vault resource or not.')
param keyVaultEnabled bool = false

@description('Specifies the name of the Key Vault resource.')
param keyVaultName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}KeyVault' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}KeyVault' : '${toLower(prefix)}-key-vault'

@description('The default action of allow or deny when no other rules match. Allowed values: Allow or Deny')
@allowed([
  'Allow'
  'Deny'
])
param keyVaultNetworkAclsDefaultAction string = 'Allow'

@description('Specifies whether the Azure Key Vault resource is enabled for deployments.')
param keyVaultEnabledForDeployment bool = true

@description('Specifies whether the Azure Key Vault resource is enabled for disk encryption.')
param keyVaultEnabledForDiskEncryption bool = true

@description('Specifies whether the Azure Key Vault resource is enabled for template deployment.')
param keyVaultEnabledForTemplateDeployment bool = true

@description('Specifies whether the soft deelete is enabled for this Azure Key Vault resource.')
param keyVaultEnableSoftDelete bool = true

@description('Specifies the object ID ofthe service principals to configure in Key Vault access policies.')
param keyVaultObjectIds array = []

@description('Specifies whether creating the Azure Storage Account resource or not.')
param storageAccountEnabled bool = false

@description('Specifies the name of the storage account')
param storageAccountName string = '${toLower(prefix)}sa'

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

@description('Specifies whether creating the API Management resource or not.')
param apiManagementEnabled bool = false

@description('Specifies the name of the API Management.')
param apiManagementName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Apim' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Apim' : '${toLower(prefix)}-apim'

@description('Specifies whether creating the Azure OpenAi resource or not.')
param openAiEnabled bool = false

@description('Specifies the name of the Azure OpenAI resource.')
param openAiName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}OpenAi' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}OpenAi' : '${toLower(prefix)}-openai'

@description('Specifies the resource model definition representing SKU.')
param openAiSku object = {
  name: 'S0'
}

@description('Specifies the identity of the OpenAI resource.')
param openAiIdentity object = {
  type: 'SystemAssigned'
}

@description('Specifies an optional subdomain name used for token-based authentication.')
param openAiCustomSubDomainName string = ''

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param openAiPublicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = []

@description('Specifies whether creating the Azure Cognitive Search resource or not.')
param cognitiveSearchEnabled bool = false

@description('Name of your Azure Cognitive Search')
@minLength(5)
@maxLength(60)
param cognitiveSearchName string = '${toLower(prefix)}-search'

@description('Specifies whether creating the Azure Container Registry resource or not.')
param containerRegistryEnabled bool = false

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

@description('Specifies whether creating the Azure IoT Hub resource or not.')
param iotHubEnabled bool = false

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

@description('Specifies whether creating the Azure Virtual Network resource or not.')
param virtualNetworkEnabled bool = false

@description('Name of your Azure Virtual Network')
param virtualNetworkName string = letterCaseType == 'UpperCamelCase' ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}VNet' : letterCaseType == 'CamelCase' ? '${toLower(prefix)}VNet' : '${toLower(prefix)}-vnet'

@description('Specifies whether creating the Azure Bastion Host resource or not.')
param bastionHostEnabled bool = false

@description('Specifies whether creating the Azure NAT Gateway resource or not.')
param natGatewayEnabled bool = false

@description('Specifies the name of the private link to the Azure OpenAI resource.')
param openAiPrivateEndpointName string = letterCaseType == 'UpperCamelCase' ? 'OpenAiPrivateEndpoint' : letterCaseType == 'CamelCase' ? 'OpenAiPrivateEndpoint' : 'openai-private-endpoint'

@description('Specifies whether creating the Azure Virtual Machine resource or not.')
param virtualMachineEnabled bool = false

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

module keyVault '../../modules/keyVault.bicep' = if (keyVaultEnabled) {
  name: 'keyVault'
  params: {
    name: keyVaultName
    networkAclsDefaultAction: keyVaultNetworkAclsDefaultAction
    enabledForDeployment: keyVaultEnabledForDeployment
    enabledForDiskEncryption: keyVaultEnabledForDiskEncryption
    enabledForTemplateDeployment: keyVaultEnabledForTemplateDeployment
    enableSoftDelete: keyVaultEnableSoftDelete
    objectIds: keyVaultObjectIds
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

module storageAccount '../../modules/storageAccount.bicep' = if (storageAccountEnabled) {
  name: 'storageAccount'
  params: {
    name: storageAccountName
    createContainers: true
    containerNames: [
      'dev'
      'prod'
    ]
    keyVaultName: keyVault.outputs.name
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

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

module apim '../../modules/apiManagement.bicep' = if (apiManagementEnabled) {
  name: 'apiManagement'
  params: {
    name: apiManagementName
    location: location
    tags: tags
  }
}

module openAi '../../modules/openAi.bicep' = if (openAiEnabled) {
  name: 'openAi'
  params: {
    name: openAiName
    sku: openAiSku
    identity: openAiIdentity
    customSubDomainName: empty(openAiCustomSubDomainName) ? toLower(openAiName) : openAiCustomSubDomainName
    publicNetworkAccess: openAiPublicNetworkAccess
    deployments: openAiDeployments
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

module cognitiveSearch '../../modules/cognitiveSearch.bicep' = if (cognitiveSearchEnabled) {
  name: 'cognitiveSearch'
  params: {
    name: cognitiveSearchName
    location: location
    tags: tags
  }
}

module containerRegistry '../../modules/containerRegistry.bicep' = if (containerRegistryEnabled) {
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

module iotHub '../../modules/iotHub.bicep' = if (iotHubEnabled) {
  name: 'iotHub'
  params: {
    name: iotHubName
    sku: iotHubSku
    location: location
    tags: tags
  }
}

module network '../../modules/virtualNetwork.bicep' = if (virtualNetworkEnabled) {
  name: 'virtualNetwork'
  params: {
    virtualNetworkName: virtualNetworkName
    bastionHostName: '${prefix}-bastion'
    bastionHostEnabled: bastionHostEnabled
    natGatewayName: '${prefix}-natgw'
    natGatewayEnabled: natGatewayEnabled
    openAiEnabled: openAiEnabled
    openAiPrivateEndpointName: openAiPrivateEndpointName
    openAiId: openAiEnabled ? openAi.outputs.id : ''
    location: location
    tags: tags
  }
}

module virtualMachine '../../modules/virtualMachine.bicep' = if (virtualMachineEnabled) {
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
