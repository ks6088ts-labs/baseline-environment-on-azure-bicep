# Private Registry for Bicep Scenario

This is a scenario for deploying a private registry for Bicep.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=bicep-private-registry
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=bicep-private-registry
```

## Publish Bicep modules to the private registry

ref. [Create private registry for Bicep modules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry?tabs=azure-cli)

```shell
cd infra

# Set the name of the Azure Container Registry deployed in the previous step
CONTAINER_REGISTRY_NAME=YourContainerRegistryName

# Login to the Azure Container Registry
az acr login -n $CONTAINER_REGISTRY_NAME

# Publish Bicep modules to the private registry
az bicep publish \
    --file ./modules/openAi.bicep \
    --target br:$CONTAINER_REGISTRY_NAME.azurecr.io/bicep/modules/openai:v1
az bicep publish \
    --file ./modules/containerRegistry.bicep \
    --target br:$CONTAINER_REGISTRY_NAME.azurecr.io/bicep/modules/containerregistry:v1
```
