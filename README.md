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

1. create GitHub environment named `dev`. ref.[Managing environments for deployment](https://docs.github.com/ja/actions/administering-github-actions/managing-environments-for-deployment)
1. install [GitHub CLI](https://cli.github.com/) and authenticate with your GitHub account.
1. update parameters in [credential.json](./scripts/credential.json) to your Azure subscription.
1. run the following command to configure both Azure resources and GitHub secrets.

```shell
sh ./scripts/configure-oidc-github.sh
```
