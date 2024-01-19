# Azure IoT Reference Architecture scenario

This is a scenario for deploying [Azure IoT Reference Architecture](https://learn.microsoft.com/ja-jp/azure/architecture/reference-architectures/iot).

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=iot-reference-architecture
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=iot-reference-architecture
```

## References

- [Azure IoT Reference Architecture](https://learn.microsoft.com/ja-jp/azure/architecture/reference-architectures/iot)
- [Quickstart: Create an Azure Stream Analytics job using Bicep](https://learn.microsoft.com/en-us/azure/stream-analytics/quick-create-bicep?tabs=CLI#review-the-bicep-file)
