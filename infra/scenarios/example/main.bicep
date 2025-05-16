// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id)

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies whether creating the Azure Log Analytics Workspace resource or not.')
param logAnalyticsEnabled bool = false

@description('Specifies the name of the Log Analytics Workspace.')
param logAnalyticsWorkspaceName string = '${toLower(prefix)}Workspace'

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

@description('Specifies whether creating the Azure Key Vault resource or not.')
param keyVaultEnabled bool = false

@description('Specifies the name of the Key Vault resource.')
param keyVaultName string = 'kv${toLower(prefix)}KeyVault'

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

@description('Specifies whether creating the Azure Cosmos DB resource or not.')
param cosmosDbEnabled bool = false

@description('Specifies the name of the Cosmos DB database.')
param cosmosDbName string = '${toLower(prefix)}cosmosdb'

@description('Specifies whether or not public network access is allowed for this account.')
@allowed([
  'Enabled'
  'Disabled'
])
param cosmosDbPublicNetworkAccess string = 'Enabled'

@description('Specifies whether creating the API Management resource or not.')
param apiManagementEnabled bool = false

@description('Specifies the name of the API Management.')
param apiManagementName string = 'apim${toLower(prefix)}Apim'

@description('Specifies whether creating the Azure App Service Plan resource or not.')
param appServicePlanEnabled bool = false

@description('Specifies the name of the Azure App Service Plan.')
param appServicePlanName string = '${toLower(prefix)}Asp'

@description('Specifies whether creating the Azure App Service resource or not.')
param appServiceEnabled bool = false

@description('Specifies the name of the Azure App Service.')
param appServiceName string = '${toLower(prefix)}As'

@description('')
param appServiceAllowedOrigins array = []

@description('Specifies whether creating the Azure Container Apps Environment resource or not.')
param containerAppsEnvironmentEnabled bool = false

@description('Specifies the name of the Azure Container Apps Environment.')
param containerAppsEnvironmentName string = '${toLower(prefix)}Environment'

@description('Specifies whether the environment only has an internal load balancer. These environments do not have a public static IP resource. They must provide infrastructureSubnetId if enabling this property')
param internal bool = false

@description('Specifies the IP range in CIDR notation assigned to the Docker bridge, network. Must not overlap with any other provided IP ranges.')
param dockerBridgeCidr string = '10.2.0.1/16'

@description('Specifies the IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. Must not overlap with any other provided IP ranges.')
param platformReservedCidr string = '10.1.0.0/16'

@description('Specifies an IP address from the IP range defined by platformReservedCidr that will be reserved for the internal DNS server.')
param platformReservedDnsIP string = '10.1.0.2'

@description('Specifies whether the Azure Container Apps environment should be zone-redundant.')
param zoneRedundant bool = true

@description('Specifies whether creating the Azure OpenAi resource or not.')
param openAiEnabled bool = false

@description('Specifies the name of the Azure OpenAI resource.')
param openAiName string = '${toLower(prefix)}OpenAi'

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

@description('Specifies whether or not public network access is allowed for this account.')
@allowed([
  'Enabled'
  'Disabled'
])
param openAiPublicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = []

@description('Specifies the location of the Azure OpenAI resource.')
param openAiLocation string = 'japaneast'

@description('Specifies whether creating the Azure Cognitive Search resource or not.')
param cognitiveSearchEnabled bool = false

@description('Name of your Azure Cognitive Search')
@minLength(5)
@maxLength(60)
param cognitiveSearchName string = '${toLower(prefix)}-search'

@description('Specifies whether or not public network access is allowed for this account.')
@allowed([
  'enabled'
  'disabled'
])
param cognitiveSearchPublicNetworkAccess string = 'enabled'

@description('Specifies whether creating the Azure Container Registry resource or not.')
param containerRegistryEnabled bool = false

@description('Name of your Azure Container Registry')
@minLength(5)
@maxLength(50)
param containerRegistryName string = '${toLower(prefix)}azurecontainerregistry'

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
param iotHubName string = '${toLower(prefix)}IotHub'

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
param virtualNetworkName string = '${toLower(prefix)}VNet'

@description('Specifies whether creating the Azure Bastion Host resource or not.')
param bastionHostEnabled bool = false

@description('Specifies whether creating the Azure NAT Gateway resource or not.')
param natGatewayEnabled bool = false

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

@description('Specifies whether creating the Azure Kubernetes Service resource or not.')
param aksClusterEnabled bool = false

@description('Specifies the name of the Azure Kubernetes Service resource.')
param aksClusterName string = '${toLower(prefix)}Aks'

module logAnalytics '../../modules/logAnalytics.bicep' = if (logAnalyticsEnabled) {
  name: 'logAnalytics'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    sku: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
    tags: tags
  }
}

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
    workspaceId: logAnalyticsEnabled ? logAnalytics.outputs.id : ''
    location: location
    tags: tags
  }
}

module storageAccount '../../modules/storageAccount.bicep' = if (storageAccountEnabled) {
  name: 'storageAccount'
  params: {
    name: storageAccountName
    containerNames: [
      'dev'
      'prod'
    ]
    workspaceId: logAnalyticsEnabled ? logAnalytics.outputs.id : ''
    location: location
    tags: tags
  }
}

module cosmosDb '../../modules/cosmosDb.bicep' = if (cosmosDbEnabled) {
  name: 'cosmosDb'
  params: {
    name: cosmosDbName
    location: location
    tags: tags
    cosmosDbDatabaseName: '${cosmosDbName}Database'
    cosmosDbContainerName: '${cosmosDbName}ContainerName'
    publicNetworkAccess: cosmosDbPublicNetworkAccess
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

module appServicePlan '../../modules/appServicePlan.bicep' = if (appServicePlanEnabled) {
  name: 'appServicePlan'
  params: {
    name: appServicePlanName
    location: location
    tags: tags
  }
}

module appService '../../modules/appService.bicep' = if (appServiceEnabled) {
  name: 'appService'
  params: {
    name: appServiceName
    location: location
    tags: tags
    appServicePlanId: appServicePlanEnabled ? appServicePlan.outputs.id : ''
    runtimeName: 'node'
    runtimeVersion: '14-lts'
    appCommandLine: ''
    scmDoBuildDuringDeployment: true
    managedIdentity: true
    allowedOrigins: appServiceAllowedOrigins
    appSettings: {
      AZURE_TENANT_ID: tenant().tenantId
      AZURE_SUBSCRIPTION_ID: subscription().subscriptionId
    }
  }
}

module containerAppsEnvironment '../../modules/containerAppsEnvironment.bicep' = if (containerAppsEnvironmentEnabled) {
  name: 'containerAppsEnvironment'
  params: {
    name: containerAppsEnvironmentName
    location: location
    tags: tags
    internal: internal
    dockerBridgeCidr: dockerBridgeCidr
    platformReservedCidr: platformReservedCidr
    platformReservedDnsIP: platformReservedDnsIP
    zoneRedundant: zoneRedundant
    workspaceName: logAnalyticsWorkspaceName
    infrastructureSubnetId: virtualNetworkEnabled ? network.outputs.infrastructureSubnetId : ''
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
    workspaceId: logAnalyticsEnabled ? logAnalytics.outputs.id : ''
    location: openAiLocation
    tags: tags
  }
}

module cognitiveSearch '../../modules/cognitiveSearch.bicep' = if (cognitiveSearchEnabled) {
  name: 'cognitiveSearch'
  params: {
    name: cognitiveSearchName
    location: location
    tags: tags
    publicNetworkAccess: cognitiveSearchPublicNetworkAccess
  }
}

module containerRegistry '../../modules/containerRegistry.bicep' = if (containerRegistryEnabled) {
  name: 'containerRegistry'
  params: {
    name: containerRegistryName
    sku: containerRegistrySku
    adminUserEnabled: containerRegistryAdminUserEnabled
    workspaceId: logAnalyticsEnabled ? logAnalytics.outputs.id : ''
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
    storageAccountId: storageAccountEnabled ? storageAccount.outputs.id : ''
    keyVaultId: keyVaultEnabled ? keyVault.outputs.id : ''
    acrId: containerRegistryEnabled && (containerRegistrySku == 'Premium') ? containerRegistry.outputs.id : ''
    openAiId: openAiEnabled ? openAi.outputs.id : ''
    location: location
    tags: tags
  }
}

module virtualMachine '../../modules/virtualMachine.bicep' = if (virtualMachineEnabled) {
  name: 'virtualMachine'
  params: {
    vmSubnetId: virtualNetworkEnabled ? network.outputs.vmSubnetId : ''
    vmAdminPasswordOrKey: vmAdminPasswordOrKey
    vmAdminUsername: vmAdminUsername
    authenticationType: authenticationType
    managedIdentityName: '${toLower(prefix)}AzureMonitorAgentManagedIdentity'
    location: location
    tags: tags
  }
}

module aksCluster '../../modules/aksCluster.bicep' = if (aksClusterEnabled) {
  name: 'aksCluster'
  params: {
    name: aksClusterName
    location: location
    tags: tags
  }
}
