[![test](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-bicep/actions/workflows/test.yml?query=branch%3Amain)

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

| Scenario                                           | Overview                                         |
| -------------------------------------------------- | ------------------------------------------------ |
| [example](./infra/scenarios/example/README.md)     | Example for describing how to use modules        |
| [iot-edge](./infra/scenarios/iot-edge/README.md)   | IoT Edge workshop                                |
| [aoai-apim](./infra/scenarios/aoai-apim/README.md) | Call Azure OpenAI Service API via API Management |
