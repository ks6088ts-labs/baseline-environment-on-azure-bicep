# Publish and subscribe to MQTT messages on Event Grid Namespace

This is a scenario for pub-sub to MQTT messages on Event Grid Namespace.

## Prepare client certificate and thumbprint

See [Generate sample client certificate and thumbprint](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-publish-and-subscribe-portal#generate-sample-client-certificate-and-thumbprint) to generate a sample client certificate and thumbprint.
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

## FIXME: Manual steps

To set up MQTT routing to Event Hubs, you need to manually set up the following resources on Azure portal.
ref. [Tutorial: Route MQTT messages to Azure Event Hubs from Azure Event Grid with the Azure portal](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-routing-to-event-hubs-portal)

- assign the Event Grid Data Sender role to yourself on the Event Grid topic
- create an event subscription with Event Hubs as the endpoint on the Event Grid topic
- configure routing in the Event Grid namespace
