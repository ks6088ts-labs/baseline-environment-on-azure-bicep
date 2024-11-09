[![infra](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/infra.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/infra.yml?query=branch%3Amain)
[![deploy](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/deploy.yml?query=branch%3Amain)

# baseline-environment-on-azure-bicep

## Prerequisites

- [GNU Make](https://www.gnu.org/software/make/)
- [Azure CLI](https://github.com/Azure/azure-cli#installation)

## Usage

See [Makefile](./infra/Makefile) for details.

```shell
❯ cd infra; make help
build                          build a bicep file
ci-test                        ci test
create-resource-group          create resource group
delete-resource-group          delete resource group
deploy                         deploy resources
deployment-create              start a deployment at resource group
deployment-what-if             execute a deployment What-If operation at resource group scope
destroy                        destroy resources
format                         format codes
info                           show information
install-deps-dev               install dependencies for development
lint                           lint codes
test                           test codes
```

## Scenarios

| Scenario                                                                   | Overview                          |
| -------------------------------------------------------------------------- | --------------------------------- |
| [workshop-azure-iot](./infra/scenarios/workshop-azure-iot/README.md)       | Workshop for Azure IoT scenario   |
| [workshop-azure-openai](./infra/scenarios/workshop-azure-openai/README.md) | Workshop for Azure OpenAI Service |

## Use GitHub Actions to connect to Azure

To configure the federated credential by following the steps below:

1. Install [GitHub CLI](https://cli.github.com/) and authenticate with GitHub.
1. Run the following commands to create a new service principal and configure OpenID Connect.

```shell
# Create a new service principal
bash scripts/create-service-principal.sh

# Configure GitHub secrets
bash scripts/configure-github-secrets.sh
```
