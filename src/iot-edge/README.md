## Develop IoT Edge modules

Follow the instructions below to develop IoT Edge modules.

- [Tutorial: Develop IoT Edge modules using Visual Studio Code](https://learn.microsoft.com/en-us/azure/iot-edge/tutorial-develop-for-linux?view=iotedge-1.4&tabs=python&pivots=iotedge-dev-ext)

```shell
DEPLOYMENT_GROUP_NAME="iotHub"
RESOURCE_GROUP_NAME="rg-iot-edge-1128"
DEVICE_NAME="mydevice"

IOT_HUB_NAME=$(az deployment group show \
    --name $DEPLOYMENT_GROUP_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --query properties.outputs.name.value \
    --output tsv)

# Monitor module twins in Azure CLI
# https://learn.microsoft.com/en-us/azure/iot-edge/how-to-monitor-module-twins?view=iotedge-1.4#monitor-module-twins-in-azure-cli
az iot hub module-twin show \
    -m '$edgeAgent' \
    -n $IOT_HUB_NAME \
    -d $DEVICE_NAME

# Communicate with edgeAgent using built-in direct methods
# Ping
az iot hub invoke-module-method \
    --method-name 'ping' \
    -n $IOT_HUB_NAME \
    -d $DEVICE_NAME \
    -m '$edgeAgent'
# {
#   "payload": null,
#   "status": 200
# }

# Restart module
az iot hub invoke-module-method \
    --method-name 'RestartModule' \
    -n $IOT_HUB_NAME \
    -d $DEVICE_NAME \
    -m '$edgeAgent' \
    --method-payload '
{
    "schemaVersion": "1.0",
    "id": "<module name>"
}'
# {
#   "payload": null,
#   "status": 200
# }

# Retrieve logs from IoT Edge deployments
# https://learn.microsoft.com/en-us/azure/iot-edge/how-to-retrieve-iot-edge-logs?view=iotedge-1.4
az iot hub invoke-module-method \
    --method-name 'GetModuleLogs' \
    -n $IOT_HUB_NAME \
    -d $DEVICE_NAME \
    -m '$edgeAgent' \
    --method-payload '
{
    "schemaVersion": "1.0",
    "items": [
        {
            "id": "edgeAgent",
            "filter": {
            "tail": 10
            }
        }
    ],
    "encoding": "none",
    "contentType": "text"
}'

```

- [How to implement IoT Edge observability using monitoring and troubleshooting](https://learn.microsoft.com/en-us/azure/iot-edge/how-to-observability?view=iotedge-1.4)
