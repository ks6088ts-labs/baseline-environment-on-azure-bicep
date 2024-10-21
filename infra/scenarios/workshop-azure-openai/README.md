# Workshop for Azure OpenAI Service

This is a scenario for [ks6088ts-labs/workshop-azure-openai](https://github.com/ks6088ts-labs/workshop-azure-openai). This provides an infrastructure for the workshop.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=workshop-azure-openai
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=workshop-azure-openai
```
