# Publish and subscribe to MQTT messages on Event Grid Namespace

This is a scenario for pub-sub to MQTT messages on Event Grid Namespace.

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

To set up MQTT pub-sub on Event Grid Namespace, you need to manually set up the following resources on Azure portal.
ref. [Quickstart: Publish and subscribe to MQTT messages on Event Grid Namespace with Azure portal](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-publish-and-subscribe-portal)

- Create clients, topic spaces and permission bindings on Event Grid Namespace

To set up MQTT routing to Event Hubs, you need to manually set up the following resources on Azure portal.
ref. [Tutorial: Route MQTT messages to Azure Event Hubs from Azure Event Grid with the Azure portal](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-routing-to-event-hubs-portal)

- assign the Event Grid Data Sender role to yourself on the Event Grid topic
- create an event subscription with Event Hubs as the endpoint on the Event Grid topic
- configure routing in the Event Grid namespace
