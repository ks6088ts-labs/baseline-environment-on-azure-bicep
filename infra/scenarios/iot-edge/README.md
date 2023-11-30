# IoT Edge Scenario
This is a scenario for describing how to deploy IoT Edge with modules.

## Deploy resources on Azure

```shell
# Create resource group
az group create \
  --name rg-iot-edge \
  --location japaneast

# Validate the scenario
az deployment group what-if \
  --resource-group rg-iot-edge \
  --template-file scenarios/iot-edge/main.bicep \
  --parameters scenarios/iot-edge/main.parameters.json \
  --parameters vmAdminPasswordOrKey="$(cat ~/.ssh/id_rsa.pub)"

# Create resources for the scenario
az deployment group create \
  --resource-group rg-iot-edge \
  --template-file scenarios/iot-edge/main.bicep \
  --parameters scenarios/iot-edge/main.parameters.json \
  --parameters vmAdminPasswordOrKey="$(cat ~/.ssh/id_rsa.pub)"

# Create device identity for edge device on IoT Hub
DEVICE_ID=YOUR_DEVICE_NAME
az iot hub device-identity create \
    --device-id $DEVICE_ID \
    --hub-name $IOT_HUB_NAME \
    --edge-enabled

# Get connection string for edge device
DEVICE_CONNECTION_STRING=$(az iot hub device-identity \
    connection-string show --device-id $DEVICE_ID --hub-name $IOT_HUB_NAME -o tsv)
```

## Install IoT Edge runtime on VM

```shell
# Connect to device via SSH
ssh azadmin@testvm-tcnuoqlqp5tm2.japaneast.cloudapp.azure.com
```

- [Create and provision an IoT Edge device on Linux using symmetric keys](https://learn.microsoft.com/en-us/azure/iot-edge/how-to-provision-single-device-linux-symmetric?view=iotedge-1.4&tabs=azure-portal%2Cubuntu)
- [Azure/iotedge-vm-deploy](https://github.com/Azure/iotedge-vm-deploy)

```shell
# Print OS information to confirm the OS version is Ubuntu 22.04
uname -a

# Install iotedge
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install moby-engine
sudo apt-get update; \
  sudo apt-get install moby-engine

# Set docker daemon.json
sudo nano /etc/docker/daemon.json
sudo systemctl restart docker

# Install iotedge
sudo apt-get update; \
   sudo apt-get install aziot-edge

# Download config.toml
sudo mkdir -p /etc/aziot
sudo wget https://raw.githubusercontent.com/Azure/iotedge-vm-deploy/master/config.toml -O /etc/aziot/config.toml

# Set connection string
DEVICE_CONNECTION_STRING="HostName=3cevkhsmyit4cIotHub.azure-devices.net;DeviceId=YOUR_DEVICE_NAME;SharedAccessKey=YOUR_SHARED_ACCESS_KEY"
sudo sed -i "s#\(connection_string = \).*#\1\"$DEVICE_CONNECTION_STRING\"#g" /etc/aziot/config.toml

# Apply config
sudo iotedge config apply -c /etc/aziot/config.toml

# Check iotedge status
sudo iotedge check
```
