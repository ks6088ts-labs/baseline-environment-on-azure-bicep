## Send telemetry to IoT Hub

To understand how to send telemetry to IoT Hub, follow the instructions below.

- [Quickstart: Send telemetry from an IoT Plug and Play device to Azure IoT Hub](https://learn.microsoft.com/en-us/azure/iot-develop/quickstart-send-telemetry-iot-hub?pivots=programming-language-python)

Following tools are helpful to monitor IoT Hub built-in event endpoint.

- [Azure IoT Hub extension for Visual Studio Code](https://github.com/microsoft/vscode-azure-iot-toolkit/wiki/Monitor-IoT-Hub-Built-in-Event-Endpoint)
- [ServiceBusExplorer](https://github.com/paolosalvatori/ServiceBusExplorer) NOTE: Windows only

## Develop IoT Edge modules

Follow the instructions below to develop IoT Edge modules.

- [Tutorial: Develop IoT Edge modules using Visual Studio Code](https://learn.microsoft.com/en-us/azure/iot-edge/tutorial-develop-for-linux?view=iotedge-1.4&tabs=python&pivots=iotedge-dev-ext)

### Local development environment

To run the sample IoT Edge modules locally, run the following commands.

```shell
# go to a sample IoT Edge module directory
cd modules/modules/filtermodule

# setup virtual environment
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# run the sample IoT Edge modules locally
LOCAL_DEBUG=true python main.py
```

## Monitor and diagnose

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
