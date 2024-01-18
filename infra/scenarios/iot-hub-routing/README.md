# IoT Hub routing scenario

This is a scenario for IoT Hub routing.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=iot-hub-routing
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=iot-hub-routing
```

## References

- [Quickstart: Deploy an Azure IoT hub and a storage account using Bicep](https://learn.microsoft.com/en-us/azure/iot-hub/quickstart-bicep-route-messages)
