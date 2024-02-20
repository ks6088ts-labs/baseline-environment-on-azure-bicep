// Parameters
@description('Specifies the name prefix.')
param prefix string = uniqueString(resourceGroup().id, location)

@description('Specifies the primary location of Azure resources.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Specifies the name of the virtual network.')
param virtualNetworkName string = '${toLower(prefix)}-vnet'

@description('Specifies the address prefixes of the virtual network.')
param virtualNetworkAddressPrefixes string = '10.0.0.0/8'

@description('Specifies the name of the subnet which contains the virtual machine.')
param vmSubnetName string = 'vm-subnet'

@description('Specifies the address prefix of the subnet which contains the virtual machine.')
param vmSubnetAddressPrefix string = '10.3.1.0/24'

@description('Specifies the Bastion subnet IP prefix. This prefix must be within vnet IP prefix address space.')
param bastionSubnetAddressPrefix string = '10.3.2.0/24'

@description('Specifies the name of the Azure Bastion resource.')
param bastionHostName string = '${toLower(prefix)}-bastion'

@description('Specifies the name of the virtual machine.')
param vmName string = 'TestVm'

@description('Specifies the size of the virtual machine.')
param vmSize string = 'Standard_DS3_v2'

@description('Specifies the image publisher of the disk image used to create the virtual machine.')
param imagePublisher string = 'Canonical'

@description('Specifies the offer of the platform image or marketplace image used to create the virtual machine.')
param imageOffer string = '0001-com-ubuntu-server-jammy'

@description('Specifies the Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
param imageSku string = '22_04-lts-gen2'

@description('Specifies the type of authentication when accessing the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

@description('Specifies the name of the administrator account of the virtual machine.')
param vmAdminUsername string

@description('Specifies the SSH Key or password for the virtual machine. SSH key is recommended.')
@secure()
param vmAdminPasswordOrKey string

@description('Specifies the storage account type for OS and data disk.')
@allowed([
  'Premium_LRS'
  'StandardSSD_LRS'
  'Standard_LRS'
  'UltraSSD_LRS'
])
param diskStorageAccountType string = 'Premium_LRS'

@description('Specifies the number of data disks of the virtual machine.')
@minValue(0)
@maxValue(64)
param numDataDisks int = 1

@description('Specifies the size in GB of the OS disk of the VM.')
param osDiskSize int = 50

@description('Specifies the size in GB of the OS disk of the virtual machine.')
param dataDiskSize int = 50

@description('Specifies the caching requirements for the data disks.')
param dataDiskCaching string = 'ReadWrite'

@description('Specifies the name of the Azure OpenAI resource.')
param openAiName string = '${toLower(prefix)}-openai'

@description('Specifies the resource model definition representing SKU.')
param openAiSku object = {
  name: 'S0'
}

@description('Specifies the identity of the OpenAI resource.')
param openAiIdentity object = {
  type: 'SystemAssigned'
}

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param openAiPublicNetworkAccess string = 'Disabled'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = [
  {
    name: 'text-embedding-ada-002'
    version: '2'
    raiPolicyName: ''
    capacity: 1
    scaleType: 'Standard'
  }
  {
    name: 'gpt-35-turbo'
    version: '0613'
    raiPolicyName: ''
    capacity: 1
    scaleType: 'Standard'
  }
]

@description('Specifies the name of the private link to the Azure OpenAI resource.')
param openAiPrivateEndpointName string = 'openai-private-endpoint'

@description('Specifies the name of the private link to the Azure Cognitive Search resource.')
param cognitiveSearchPrivateEndpointName string = 'cognitive-search-private-endpoint'

@description('Specifies the name of the Azure Cognitive Search resource.')
param cognitiveSearchName string = '${toLower(prefix)}-search'

@description('Specifies whether or not public network access is allowed for this account.')
@allowed([
  'enabled'
  'disabled'
])
param cognitiveSearchPublicNetworkAccess string = 'enabled'

// modules
module network 'network.bicep' = {
  name: 'network'
  params: {
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressPrefixes: virtualNetworkAddressPrefixes
    vmSubnetName: vmSubnetName
    vmSubnetAddressPrefix: vmSubnetAddressPrefix
    vmSubnetNsgName: '${vmSubnetName}Nsg'
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    bastionSubnetNsgName: 'AzureBastionSubnetNsg'
    bastionHostName: bastionHostName
    openAiPrivateEndpointName: openAiPrivateEndpointName
    openAiId: openAi.outputs.id
    cognitiveSearchPrivateEndpointName: cognitiveSearchPrivateEndpointName
    cognitiveSearchId: cognitiveSearch.outputs.id
    location: location
    tags: tags
  }
}

module jumpboxVirtualMachine 'virtualMachine.bicep' = {
  name: 'jumpboxVirtualMachine'
  params: {
    vmName: vmName
    vmSize: vmSize
    vmSubnetId: network.outputs.vmSubnetId
    imagePublisher: imagePublisher
    imageOffer: imageOffer
    imageSku: imageSku
    authenticationType: authenticationType
    vmAdminUsername: vmAdminUsername
    vmAdminPasswordOrKey: vmAdminPasswordOrKey
    diskStorageAccountType: diskStorageAccountType
    numDataDisks: numDataDisks
    osDiskSize: osDiskSize
    dataDiskSize: dataDiskSize
    dataDiskCaching: dataDiskCaching
    managedIdentityName: '${toLower(prefix)}-azure-monitor-agent-managed-identity'
    location: location
    tags: tags
  }
}

module openAi 'openAi.bicep' = {
  name: 'openAi'
  params: {
    name: openAiName
    sku: openAiSku
    identity: openAiIdentity
    customSubDomainName: toLower(openAiName)
    publicNetworkAccess: openAiPublicNetworkAccess
    deployments: openAiDeployments
    location: location
    tags: tags
  }
}

module cognitiveSearch 'cognitiveSearch.bicep' =  {
  name: 'cognitiveSearch'
  params: {
    name: cognitiveSearchName
    publicNetworkAccess: cognitiveSearchPublicNetworkAccess
    location: location
    tags: tags
  }
}
