#!/bin/sh

set -eux

# Use GitHub Actions to connect to Azure:
# https://learn.microsoft.com/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux

# get the directory of the script
SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)

# get the name of the current directory
appName=$(basename "$(pwd)")

# Azure sign in
az login

# Get the current Azure subscription ID
subscriptionId=$(az account show --query 'id' --output tsv)

# Create a new Azure Active Directory application
appId=$(az ad app create --display-name "$appName" --query appId --output tsv)

# Create a new service principal for the application
assigneeObjectId=$(az ad sp create --id "$appId" --query id --output tsv)

# Get the tenant ID of the Azure subscription
tenantId=$(az ad sp show --id "$appId" --query appOwnerOrganizationId --output tsv)

# Assign the 'Contributor' role to the service principal for the subscription
az role assignment create --role contributor \
    --subscription "$subscriptionId" \
    --assignee-object-id "$assigneeObjectId" \
    --assignee-principal-type ServicePrincipal \
    --scope /subscriptions/"$subscriptionId"

# Assign the 'Contributor' role to the service principal for the subscription
az ad app federated-credential create \
    --id "$appId" \
    --parameters "$SCRIPT_DIR"/credential.json

# Dump parameters to the console
echo "AZURE_CLIENT_ID: $appId"
echo "AZURE_SUBSCRIPTION_ID: $subscriptionId"
echo "AZURE_TENANT_ID: $tenantId"
