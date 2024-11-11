#!/bin/sh

# for debugging, use `set -eux` instead of `set -eu`
set -eu

# verify the GitHub CLI is installed
if ! command -v gh > /dev/null 2>&1; then
    echo "GitHub CLI is not installed. Please install it first."
    echo "https://cli.github.com/"
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

APPLICATION_ID=$(az ad sp list --display-name "$APP_NAME" --query "[0].appId" --output tsv)
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
SUBSCRIPTION_NAME=$(az account show --query name --output tsv)
TENANT_ID=$(az account show --query tenantId --output tsv)

echo "Are you sure you want to set the following secrets?"
echo "> APPLICATION_ID: $APPLICATION_ID"
echo "> SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "> SUBSCRIPTION_NAME: $SUBSCRIPTION_NAME"
echo "> TENANT_ID: $TENANT_ID"
echo "> GITHUB_ENV_NAME: $GITHUB_ENV_NAME"
echo "> GITHUB_REPOSITORY: $GITHUB_REPOSITORY"

# type `y` to proceed
printf "Do you want to proceed? [y/N]: "
read -r response
if [ "$response" != "y" ]; then
    echo "Operation aborted."
    exit 1
fi

# Create a new environment
# https://github.com/cli/cli/issues/5149
# https://stackoverflow.com/a/71388564/4457856
gh api --method PUT -H "Accept: application/vnd.github+json" \
    repos/"$GITHUB_REPOSITORY"/environments/"$GITHUB_ENV_NAME"

# Set secrets for the environment
gh secret set --env "$GITHUB_ENV_NAME" AZURE_CLIENT_ID       --body "$APPLICATION_ID"
gh secret set --env "$GITHUB_ENV_NAME" AZURE_SUBSCRIPTION_ID --body "$SUBSCRIPTION_ID"
gh secret set --env "$GITHUB_ENV_NAME" AZURE_TENANT_ID       --body "$TENANT_ID"
