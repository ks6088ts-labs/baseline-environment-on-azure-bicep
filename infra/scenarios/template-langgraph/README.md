# template-langgraph Scenario

This is a scenario for [template-langgraph](https://github.com/ks6088ts-labs/template-langgraph), which is a sample application demonstrating the power of Azure and LangGraph for building AI applications.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=template-langgraph
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
