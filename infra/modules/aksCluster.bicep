// Parameters
@description('Name of your AKS service.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string = name

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_B2ls_v2'

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'azureuser'

// workaround: https://github.com/Azure/bicep-types-az/issues/1523
resource sshKeyGenScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'sshKeyGenScript-${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.51.0'
    timeout: 'PT15M'
    cleanupPreference: 'Always'
    retentionInterval: 'PT1H'
    scriptContent: '''
      ssh-keygen -f aksCluster -t rsa -C azureuser
      privateKey=$(cat aksCluster)
      publicKey=$(cat 'aksCluster.pub')
      json="{\"keyInfo\":{\"privateKey\":\"$privateKey\",\"publicKeys\":[{\"keyData\":\"$publicKey\"}]}}"
      echo "$json" > $AZ_SCRIPTS_OUTPUT_PATH
    '''
  }
}

resource aks 'Microsoft.ContainerService/managedClusters@2023-09-02-preview' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: '1.27.7'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
        vmSize: agentVMSize
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        maxPods: 110
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        enableNodePublicIP: false
        osSKU: 'Ubuntu'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: sshKeyGenScript.properties.outputs.keyInfo.publicKeys
      }
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
