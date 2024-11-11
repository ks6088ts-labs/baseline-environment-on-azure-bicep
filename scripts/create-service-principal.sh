#!/bin/sh

# Use GitHub Actions to connect to Azure:
# https://learn.microsoft.com/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux

# for debugging, use `set -eux` instead of `set -eu`
set -eu

# verify the Azure CLI is installed
if ! command -v az > /dev/null 2>&1; then
    echo "Azure CLI is not installed. Please install it first."
    echo "https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# type GitHub environment name
echo "Enter the name of the GitHub environment: (e.g. 'ci', 'development', 'production')"
printf "GITHUB_ENV_NAME="
read -r GITHUB_ENV_NAME

# type your github repository
echo "Enter the name of the GitHub repository: (e.g. 'ks6088ts-labs/baseline-environment-on-azure-bicep')"
printf "GITHUB_REPOSITORY="
read -r GITHUB_REPOSITORY

# type the name of the application
echo "Enter the name of the application: (e.g. 'baseline-environment-on-azure-bicep_ci')"
printf "APP_NAME="
read -r APP_NAME

echo "Are you sure you want to create a new service principal for the following application?"
echo "> GITHUB_ENV_NAME: $GITHUB_ENV_NAME"
echo "> GITHUB_REPOSITORY: $GITHUB_REPOSITORY"
echo "> APP_NAME: $APP_NAME"

# type `y` to proceed
printf "Do you want to proceed? [y/N]: "
read -r response
if [ "$response" != "y" ]; then
    echo "Operation aborted."
    exit 1
fi

# Azure sign in
az login

# Confirm the details for the currently logged-in user
az ad signed-in-user show

# Get the current Azure subscription ID
subscriptionId=$(az account show --query 'id' --output tsv)

# Get the tenant ID of the Azure subscription
tenantId=$(az account show --query tenantId --output tsv)

# Create a new application
appId=$(az ad app create --display-name "$APP_NAME" --query appId --output tsv)

# Create a new service principal for the application
assigneeObjectId=$(az ad sp create --id "$appId" --query id --output tsv)

# Assign the 'Contributor' role to the service principal for the subscription
az role assignment create --role contributor \
    --subscription "$subscriptionId" \
    --assignee-object-id "$assigneeObjectId" \
    --assignee-principal-type ServicePrincipal \
    --scope /subscriptions/"$subscriptionId"

# create a json file for the credential
cat <<EOF > .credential.json
{
  "name": "$APP_NAME",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:$GITHUB_REPOSITORY:environment:$GITHUB_ENV_NAME",
  "description": "federated identity credential for $APP_NAME",
  "audiences": ["api://AzureADTokenExchange"]
}
EOF

# Assign the 'Contributor' role to the service principal for the subscription
az ad app federated-credential create \
    --id "$appId" \
    --parameters .credential.json

# Dump parameters to the console
echo "AZURE_CLIENT_ID: $appId"
echo "AZURE_SUBSCRIPTION_ID: $subscriptionId"
echo "AZURE_TENANT_ID: $tenantId"
