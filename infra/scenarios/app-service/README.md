# App Service Scenario

This is a scenario for describing how to deploy web applications on Azure App Service

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=app-service
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=app-service
```

## Deploy a web application

```shell
# Clone the repository
git clone git@github.com:Azure-Samples/msdocs-python-fastapi-webapp-quickstart.git
cd msdocs-python-fastapi-webapp-quickstart

# Set up the environment
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Run the web app locally
uvicorn main:app --reload

# Create a zip file for deployment under the current directory
zip -r app.zip . -x ".venv/*" ".git/*" ".github/*" "app.zip" "infra/*" "*.pyc"

# Deploy to Azure
RESOURCE_GROUP_NAME=rg-app-service
RESOURCE_TOKEN=abcde
APP_SERVICE_NAME=app${RESOURCE_TOKEN}
ZIP_FILE_PATH=app.zip

az webapp deploy \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $APP_SERVICE_NAME \
    --src-path $ZIP_FILE_PATH
```

## References

- [Azure App Service Logging: How to Monitor Your Web Apps in Real-Time](https://techcommunity.microsoft.com/blog/appsonazureblog/azure-app-service-logging-how-to-monitor-your-web-apps-in-real-time/3800390)
