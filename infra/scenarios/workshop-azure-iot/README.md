# Workshop for Azure IoT scenario

This is a scenario for [ks6088ts-labs/workshop-azure-iot](https://github.com/ks6088ts-labs/workshop-azure-iot). This provides an infrastructure for the workshop.

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
