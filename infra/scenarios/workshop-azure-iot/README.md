# Workshop for Azure IoT scenario

This is a scenario for [ks6088ts-labs/workshop-azure-iot](https://github.com/ks6088ts-labs/workshop-azure-iot). This provides an infrastructure for the workshop. You can deploy the resources on Azure by clicking the button below.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fks6088ts-labs%2Fbaseline-environment-on-azure-bicep%2Fmain%2Finfra%2Fscenarios%2Fworkshop-azure-iot%2Fazuredeploy.json)

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=workshop-azure-iot
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=workshop-azure-iot
```

## Update azuredeploy.json

```shell
cd infra/scenarios/workshop-azure-iot

az bicep build \
    --file main.bicep \
    --outfile azuredeploy.json
```
