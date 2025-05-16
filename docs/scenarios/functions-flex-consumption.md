# Azure functions Flex Consumption Scenario

This is a scenario for describing how to deploy Azure Functions on Flex Consumption plan.

## Deploy resources on Azure

```shell
git clone https://github.com/Azure-Samples/azure-functions-flex-consumption-samples.git
cd azure-functions-flex-consumption-samples/IaC/bicep/

RANDOM_TOKEN=$(openssl rand -hex 4)
DEPLOYMENT_NAME="flex-consumption-$RANDOM"

az deployment sub create \
    --name $DEPLOYMENT_NAME \
    --location japaneast \
    --template-file main.bicep \
    --parameters main.bicepparam
```

## Destroy resources on Azure

```shell
RESOURCE_GROUP_NAME="your-resource-group-name"

az group delete \
    --name $RESOURCE_GROUP_NAME \
    --yes
```

## Deploy an Azure Function

```shell
# Clone the repository
git clone git@github.com:Azure-Samples/functions-quickstart-python-http-azd.git
cd functions-quickstart-python-http-azd

# Set up the environment
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Run the function locally
func start

# Deploy to Azure
func azure functionapp publish $FUNC_APP_NAME --python --force
```

## References

**Docs**

- [Deployment technologies in Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies?tabs=windows)
- [Develop Azure Functions locally using Core Tools > Publish to Azure](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-typescript#publish)
- [func azure functionapp publish](https://learn.microsoft.com/en-us/azure/azure-functions/functions-core-tools-reference?tabs=v2#func-azure-functionapp-publish)

**Codes**

- [Azure-Samples/azure-functions-flex-consumption-samples](https://github.com/Azure-Samples/azure-functions-flex-consumption-samples)
- [Azure-Samples/functions-quickstart-typescript-azd](https://github.com/Azure-Samples/functions-quickstart-typescript-azd)
- [Azure-Samples/functions-quickstart-python-http-azd](https://github.com/Azure-Samples/functions-quickstart-python-http-azd)
