# Publish and subscribe to MQTT messages on Event Grid Namespace

This is a scenario for pub-sub to MQTT messages on Event Grid Namespace.

## Set up Bicep parameters

### Prepare client certificate and thumbprint

Follow the procedure described in [Generate sample client certificate and thumbprint](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-publish-and-subscribe-portal#generate-sample-client-certificate-and-thumbprint) to generate a sample client certificate and thumbprint.
Then overwrite thumbprints parameters for each client defined in [main.parameters.bicepparam](./main.parameters.bicepparam).

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=event-grid-mqtt
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=event-grid-mqtt
```

## Reference

- [Tutorial: Route MQTT messages to Azure Event Hubs from Azure Event Grid with the Azure portal](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-routing-to-event-hubs-portal)
