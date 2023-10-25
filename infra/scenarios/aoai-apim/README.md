# AOAI APIM Scenario

This is a scenario for describing how to call AOAI API via APIM.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=aoai-apim
```

FIXME: automate following manual steps

**1. Add API definition**

Refer to [Azure/azure-rest-api-specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/cognitiveservices/data-plane/AzureOpenAI) repo to see the latest version of AOAI API.
To download the OpenAPI spec, run the following command:

```shell
# Download the OpenAPI spec
STATUS=preview
VERSION=2023-10-01-preview

mkdir -p artifacts
curl -o artifacts/aoai-$VERSION.json "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/main/specification/cognitiveservices/data-plane/AzureOpenAI/inference/$STATUS/$VERSION/inference.json"
```

See [the prodcedure](https://github.com/Azure-Samples/openai-python-enterprise-logging/blob/main/README.ja.md#api-management) to add an API to APIM.

Remove following `servers` section from the OpenAPI spec file.

````json
  "servers": [
    {
      "url": "https://{endpoint}/openai",
      "variables": {
        "endpoint": {
          "default": "your-resource-name.openai.azure.com"
        }
      }
    }
  ],```
````

Add API definition to APIM from `OpenAPI` in APIM settings page of Azure Portal and set `API URL suffix` to `openai`

**2. Update API Settings**

- select `set headers` to set `api-key` to $AOAI_API_KEY
- set backend url to `https://$AOAI_NAME.openai.azure.com/openai`

```xml
<policies>
    <inbound>
        <base />
        <set-header name="api-key" exists-action="append">
            <value>$YOUR_AOAI_API_KEY</value>
        </set-header>
        <set-backend-service base-url="https://$YOUR_AOAI_API_ENDPOINT.openai.azure.com/openai" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```

## Tips

### Purge resources

See [Azure REST API reference](https://learn.microsoft.com/en-us/rest/api/azure/) to know how to purge resources.
For example, to purge APIM service, see following documents.

- [Deleted Services - List By Subscription](https://learn.microsoft.com/en-us/rest/api/apimanagement/current-ga/deleted-services/list-by-subscription?tabs=HTTP)
- [Azure Api management purge](https://stackoverflow.com/questions/67940295/azure-api-management-purge)

```shell
LOCATION=japaneast
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

az rest \
  --method get \
  -u "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.ApiManagement/deletedservices?api-version=2022-08-01" | jq -r '.value[]' | jq -r '.name'

SERVICE_NAME=aoai-apim

az rest \
  --method delete \
  --header "Accept=application/json" \
  -u "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.ApiManagement/locations/$LOCATION/deletedservices/$SERVICE_NAME?api-version=2022-08-01"
```
