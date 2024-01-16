# IoT Hub Device Provisioning Service Scenario

This is a scenario for setting up IoT Hub Device Provisioning Service.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=iot-hub-dps
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=iot-hub-dps
```

## References

- [Quickstart: Send telemetry from a device to an IoT hub and monitor it with the Azure CLI](https://learn.microsoft.com/en-us/azure/iot-hub/quickstart-send-telemetry-cli)
- [Quickstart: Control a device connected to an IoT hub](https://learn.microsoft.com/en-us/azure/iot-hub/quickstart-control-device?pivots=programming-language-python)
- [Quickstart: Provision a simulated symmetric key device](https://learn.microsoft.com/en-us/azure/iot-dps/quick-create-simulated-device-symm-key?pivots=programming-language-python)
- [github.com/Azure/azure-iot-sdk-python](https://github.com/Azure/azure-iot-sdk-python)
- [Video: IoT Demo: DevOps for IoT Apps](https://www.youtube.com/watch?v=keZZVtQAcxY)
- [Azure IoT Hub Device Provisioning Service (DPS) and Infrastructure as Code (IaC)](https://azure.github.io/IoTTrainingPack/modules/DevOps/azure-iot-hub-dps.html)
- [IoT Hub Device Provisioning Service とは？超概要](https://qiita.com/mstakaha1113/items/231c859d7427b466d4ad)
- [IoT Hub Device Provisioning Service とは？を作りながら理解する](https://qiita.com/mstakaha1113/items/1ccaaf445ea6f7ffd76c)
