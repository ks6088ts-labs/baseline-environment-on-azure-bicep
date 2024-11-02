SOURCE_FILES ?= $(shell find . -type f -name '*.bicep' -print)

# Git
GIT_REVISION ?= $(shell git rev-parse --short HEAD)
GIT_TAG ?= $(shell git describe --tags --abbrev=0 --always | sed -e s/v//g)

# Azure CLI
SUBSCRIPTION_ID ?= $(shell az account show --query id --output tsv)
SUBSCRIPTION_NAME ?= $(shell az account show --query name --output tsv)
TENANT_ID ?= $(shell az account show --query tenantId --output tsv)

SCENARIO ?= example
TEMPLATE_FILE ?= scenarios/$(SCENARIO)/main.bicep
PARAMETERS_FILE ?= scenarios/$(SCENARIO)/main.parameters.bicepparam

RESOURCE_GROUP_NAME ?= rg-$(SCENARIO)
TEST_RESOURCE_GROUP_NAME ?= test-baseline-environment-on-azure-bicep
LOCATION ?= japaneast

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.DEFAULT_GOAL := help

.PHONY: info
info: ## show information
	@echo "SUBSCRIPTION_ID: $(SUBSCRIPTION_ID)"
	@echo "SUBSCRIPTION_NAME: $(SUBSCRIPTION_NAME)"
	@echo "TENANT_ID: $(TENANT_ID)"
	@echo "GIT_REVISION: $(GIT_REVISION)"
	@echo "GIT_TAG: $(GIT_TAG)"

.PHONY: install-deps-dev
install-deps-dev: ## install dependencies for development
	@which az || echo "Please install Azure CLI: https://github.com/Azure/azure-cli#installation"

.PHONY: format
format: ## format codes
	@$(foreach file,$(SOURCE_FILES),az bicep format --file $(file) --insert-final-newline;)

.PHONY: lint
lint: ## lint codes
	@echo "lint: Skip since not implemented yet"

.PHONY: build
build: ## build a bicep file
	@az bicep build \
		--file $(TEMPLATE_FILE) \
		--stdout

.PHONY: test
test: ## test codes
	@echo "test: Skip since not implemented yet"

.PHONY: ci-test
ci-test: ## ci test
	make create-resource-group RESOURCE_GROUP_NAME=$(TEST_RESOURCE_GROUP_NAME)
	@for dir in $(shell find scenarios/* -type d) ; do \
		echo "Test: $$dir" ; \
		make _ci-test-base SCENARIO=$$(basename $$dir) RESOURCE_GROUP_NAME=$(TEST_RESOURCE_GROUP_NAME) || exit 1 ; \
	done
	make delete-resource-group RESOURCE_GROUP_NAME=$(TEST_RESOURCE_GROUP_NAME)

.PHONY: _ci-test-base
_ci-test-base: install-deps-dev lint build test deployment-what-if

.PHONY: create-resource-group
create-resource-group: ## create resource group
	az group create \
		--name $(RESOURCE_GROUP_NAME) \
		--location $(LOCATION)

.PHONY: delete-resource-group
delete-resource-group: ## delete resource group
	az group delete --name $(RESOURCE_GROUP_NAME) --yes


DEPLOYMENT_GROUP_SUBCOMMAND ?=

.PHONY: deployment-create
deployment-create: ## start a deployment at resource group
	make _deploy-base DEPLOYMENT_GROUP_SUBCOMMAND=create

.PHONY: deployment-what-if
deployment-what-if: ## execute a deployment What-If operation at resource group scope
	make _deploy-base DEPLOYMENT_GROUP_SUBCOMMAND=what-if

.PHONY: _deploy-base
_deploy-base:
	az deployment group $(DEPLOYMENT_GROUP_SUBCOMMAND) \
		--resource-group $(RESOURCE_GROUP_NAME) \
		--template-file $(TEMPLATE_FILE) \
		--parameters $(PARAMETERS_FILE)

.PHONY: deploy
deploy: create-resource-group deployment-what-if deployment-create ## deploy resources

.PHONY: destroy
destroy: delete-resource-group ## destroy resources
