# template-langgraph Scenario

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fks6088ts-labs%2Fbaseline-environment-on-azure-bicep%2Frefs%2Fheads%2Fmain%2Finfra%2Fscenarios%2Ftemplate-langgraph%2Fazuredeploy.json)

This is a scenario for [template-langgraph](https://github.com/ks6088ts-labs/template-langgraph), which is a sample application demonstrating the power of Azure and LangGraph for building AI applications.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=template-langgraph

# FIXME: From azure portal, set container image to ks6088ts/template-langgraph:latest on DockerHub manually.
# - set image to ks6088ts/template-langgraph:latest on DockerHub
# - set startup command to `fastapi run --host 0.0.0.0 --port 8000 template_langgraph/services/fastapis/main.py`
# - restart the app service
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=template-langgraph
```

## Update azuredeploy.json

```shell
cd infra/scenarios/template-langgraph

az bicep build \
    --file main.bicep \
    --outfile azuredeploy.json
```

## References

- [Quickstart: Create an Azure AI Foundry resource using a Bicep file](https://learn.microsoft.com/azure/ai-foundry/how-to/create-resource-template?tabs=cli)
- [Azure AI Foundry Documentation Samples](https://github.com/azure-ai-foundry/foundry-samples)
- [Manage Azure Cosmos DB for NoSQL resources with Bicep](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/manage-with-bicep)
