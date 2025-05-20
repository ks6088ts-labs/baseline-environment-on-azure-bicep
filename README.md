[![infra](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/infra.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/infra.yml?query=branch%3Amain)
[![deploy](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/deploy.yml?query=branch%3Amain)

# baseline-environment-on-azure-bicep

## Overview

This repository contains Bicep templates for deploying baseline environments on Azure. It provides a structured approach to provision various Azure resources using Infrastructure as Code (IaC) with Bicep.

The project offers multiple deployment scenarios for common Azure solutions, including IoT, OpenAI, and other services. Using this repository, you can easily deploy these scenarios to your Azure subscription with minimal effort.

### What is Bicep?

[Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) is a Domain Specific Language (DSL) for deploying Azure resources. It offers a more concise syntax compared to JSON ARM templates while maintaining compatibility with Azure Resource Manager.

## Prerequisites

Before using this repository, make sure you have the following tools installed:

### Required Tools

- **[GNU Make](https://www.gnu.org/software/make/)** - Used for running commands defined in the Makefile
  - **Windows**: Install via [Chocolatey](https://chocolatey.org/): `choco install make`
  - **macOS**: Install via [Homebrew](https://brew.sh/): `brew install make`
  - **Linux**: Install via package manager, e.g., `sudo apt-get install make`

- **[Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)** - Command-line tool for Azure
  - **Windows**: [Download installer](https://aka.ms/installazurecliwindows)
  - **macOS**: `brew install azure-cli`
  - **Linux**: [Follow these instructions](https://docs.microsoft.com/cli/azure/install-azure-cli-linux)

### Azure Requirements

- **Azure Subscription** - You need an active Azure subscription
  - If you don't have one, [create a free account](https://azure.microsoft.com/free/)
  
- **Azure CLI login** - Log in to your Azure account using:
  ```shell
  az login
  ```

- **Bicep CLI** - The Bicep CLI is installed automatically with Azure CLI, but ensure it's up to date:
  ```shell
  az bicep install
  az bicep upgrade
  ```

## Getting Started

Follow these steps to deploy your first environment:

1. **Clone the repository**
   ```shell
   git clone https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep.git
   cd baseline-environment-on-azure-bicep
   ```

2. **Log in to Azure**
   ```shell
   az login
   ```

3. **Select your subscription** (if you have multiple)
   ```shell
   az account set --subscription "<your-subscription-id-or-name>"
   ```

4. **Choose a scenario to deploy** (see Scenarios section below)
   ```shell
   # For example, to deploy the example scenario:
   cd infra
   make deploy SCENARIO=example
   ```

5. **Verify the deployment**
   ```shell
   az group list -o table
   ```

## Usage

The repository uses a Makefile to simplify common operations. Here are the main commands available:

```shell
cd infra
make help  # Shows available commands
```

### Common Commands

- **Show information about your Azure environment**
  ```shell
  make info
  ```

- **Deploy a specific scenario**
  ```shell
  make deploy SCENARIO=<scenario-name>
  ```

- **Preview changes before deployment (What-If)**
  ```shell
  make deployment-what-if SCENARIO=<scenario-name>
  ```

- **Delete resources for a scenario**
  ```shell
  make destroy SCENARIO=<scenario-name>
  ```

- **Create a resource group manually**
  ```shell
  make create-resource-group RESOURCE_GROUP_NAME=<group-name> LOCATION=<azure-region>
  ```

- **Build a Bicep template**
  ```shell
  make build SCENARIO=<scenario-name>
  ```

### Customizing Deployments

You can customize deployments by:

1. Modifying the parameter files in `infra/scenarios/<scenario-name>/main.parameters.bicepparam`
2. Setting environment variables:
   ```shell
   # Example: Deploy to a different location
   make deploy SCENARIO=example LOCATION=westus2
   ```

## Scenarios

This repository offers several deployment scenarios for various Azure services:

| Scenario | Overview | Use Case |
| -------- | -------- | -------- |
| [example](./infra/scenarios/example/README.md) | Basic example showing how to use modules | Getting started |
| [workshop-azure-iot](./infra/scenarios/workshop-azure-iot/README.md) | Workshop for Azure IoT scenario | IoT device management and data processing |
| [workshop-azure-openai](./infra/scenarios/workshop-azure-openai/README.md) | Workshop for Azure OpenAI Service | AI/ML applications and language models |
| [event-grid-mqtt](./infra/scenarios/event-grid-mqtt/README.md) | Event Grid with MQTT protocol | Event-driven architecture with MQTT |
| [iot-edge](./infra/scenarios/iot-edge/README.md) | IoT Edge deployment | Edge computing for IoT devices |
| [app-service](./infra/scenarios/app-service/README.md) | Azure App Service deployment | Web application hosting |

Each scenario has its own README file with specific instructions and details.

## Use GitHub Actions to connect to Azure

This repository includes GitHub Actions workflows to automate deployments. To configure the connection between GitHub and Azure, follow these steps:

### Setting up GitHub Actions with Azure

1. **Install the GitHub CLI**
   - Follow the installation instructions at [GitHub CLI](https://cli.github.com/)
   - Authenticate with GitHub:
     ```shell
     gh auth login
     ```

2. **Create and configure the necessary Azure resources**
   ```shell
   # Create a new service principal
   bash scripts/create-service-principal.sh

   # Configure GitHub secrets
   bash scripts/configure-github-secrets.sh

   # Add permissions to the service principal (if needed)
   bash scripts/add-permissions-to-service-principal.sh
   ```

3. **Provide information when prompted**
   - You'll need to enter:
     - GitHub environment name (e.g., 'development', 'production')
     - GitHub repository name (in format 'username/repo')
     - Application name for the service principal

4. **Verify the setup**
   - Check the GitHub repository settings to confirm that secrets were added properly
   - Test the workflow by making a small change and pushing it to your repository

## Troubleshooting

### Common Issues

1. **Azure CLI not logged in**
   - Error: `ERROR: Please run 'az login' to setup account.`
   - Solution: Run `az login` to authenticate with Azure

2. **Insufficient permissions**
   - Error: `ERROR: The client has permission to perform action on resource '...' but the resource was not found.`
   - Solution: Ensure your account has the necessary permissions (Owner or Contributor)

3. **Resource name already exists**
   - Error: `Resource with name '...' already exists.`
   - Solution: Use a different resource group name or delete the existing resources

### Getting Help

- Check Azure Bicep documentation: [Microsoft Learn](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- Search for error messages in [Azure documentation](https://docs.microsoft.com/azure/)
- Check [issues in this repository](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/issues)

## Contributing

Contributions to this repository are welcome! To contribute:

1. Fork the repository
2. Create a new branch for your feature
3. Make your changes
4. Submit a pull request

See the [documentation](./docs/README.md) for more information about Azure landing zones and references used in this project.
