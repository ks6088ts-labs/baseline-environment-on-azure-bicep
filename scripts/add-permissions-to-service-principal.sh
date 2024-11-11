#!/bin/sh

# for debugging, use `set -eux` instead of `set -eu`
set -eu

# verify the Azure CLI is installed
if ! command -v az > /dev/null 2>&1; then
    echo "Azure CLI is not installed. Please install it first."
    echo "https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# type the name of the application
echo "Enter the name of the application: (e.g. 'baseline-environment-on-azure-bicep_ci')"
printf "APP_NAME="
read -r APP_NAME

echo "Are you sure you want to add permissions to the following service principal?"
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

APPLICATION_ID=$(az ad sp list --display-name "$APP_NAME" --query "[0].appId" --output tsv)
MICROSOFT_GRAPH_API_ID="00000003-0000-0000-c000-000000000000"

# Add permissions to the service principal for Microsoft Graph API
# Domain.Read.All, Group.ReadWrite.All, GroupMember.ReadWrite.All, User.ReadWrite.All, Application.ReadWrite.All
PERMISSIONS="dbb9058a-0e50-45d7-ae91-66909b5d4664 62a82d76-70ea-41e2-9197-370581804d09 dbaae8cf-10b5-4b86-a4a1-f871c94c6695 741f803b-c850-494e-b5df-cde7c675a1ca 1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9"

for permission in $PERMISSIONS; do
  az ad app permission add \
    --id $APPLICATION_ID \
    --api $MICROSOFT_GRAPH_API_ID \
    --api-permissions $permission=Role
done

# grant admin consent
az ad app permission admin-consent --id $APPLICATION_ID
