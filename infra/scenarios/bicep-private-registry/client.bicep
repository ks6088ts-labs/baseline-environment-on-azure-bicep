// Azure resources using Bicep modules from the private registry
// FIXME: override the Azure Container Registry name
module acr 'br:yourcontainerregistry.azurecr.io/bicep/modules/containerregistry:v1' = {
  name: 'privateRegistryClientTest'
  params: {
    name: 'yourContainerRegistryName'
  }
}
