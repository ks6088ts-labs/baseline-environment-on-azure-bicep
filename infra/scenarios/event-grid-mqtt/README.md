# Publish and subscribe to MQTT messages on Event Grid Namespace

This is a scenario for pub-sub to MQTT messages on Event Grid Namespace.

## Route MQTT messages to Azure Event Hubs from Azure Event Grid

### 1. Generate certificates and thumbprints for clients.

Follow the procedure described in [Generate sample client certificate and thumbprint](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-publish-and-subscribe-portal#generate-sample-client-certificate-and-thumbprint) to generate a sample client certificate and thumbprint.

```shell
# create root and intermediate certificates
step ca init \
    --deployment-type standalone \
    --name MqttAppSamplesCA \
    --dns localhost \
    --address 127.0.0.1:443 \
    --provisioner MqttAppSamplesCAProvisioner

# create a certificate for the client
mkdir -p artifacts
CLIENT_ID=client1-authn-ID
step certificate create $CLIENT_ID artifacts/$CLIENT_ID.pem artifacts/$CLIENT_ID.key \
    --ca ~/.step/certs/intermediate_ca.crt \
    --ca-key ~/.step/secrets/intermediate_ca_key \
    --no-password \
    --insecure \
    --not-after 2400h

# view the thumbprint
step certificate fingerprint artifacts/$CLIENT_ID.pem
```

### 2. Overwrite parameters for Bicep

Overwrite principal ID and thumbprints parameters for each client defined in [main.parameters.bicepparam](./main.parameters.bicepparam).

### 3. Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=event-grid-mqtt
```

### 4. Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=event-grid-mqtt
```

## Reference

- [Quickstart: Publish and subscribe to MQTT messages on Event Grid Namespace with Azure portal](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-publish-and-subscribe-portal)
- [Tutorial: Route MQTT messages to Azure Event Hubs from Azure Event Grid with the Azure portal](https://learn.microsoft.com/en-us/azure/event-grid/mqtt-routing-to-event-hubs-portal)
