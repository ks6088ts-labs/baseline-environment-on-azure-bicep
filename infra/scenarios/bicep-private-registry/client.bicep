// Azure resources using Bicep modules from the private registry
module acr 'br:yourcontainerregistry.azurecr.io/bicep/modules/containerregistry:v1' = {
  name: 'privateRegistryClientTest'
  params: {
    name: 'yourContainerRegistryName'
  }
}
