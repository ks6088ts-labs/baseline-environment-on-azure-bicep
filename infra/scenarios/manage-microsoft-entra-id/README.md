# Manage Microsoft Entra ID scenario

This is a scenario for describing how to manage Microsoft Entra ID.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=manage-microsoft-entra-id
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=manage-microsoft-entra-id
```

## References

- [Get access without a user](https://learn.microsoft.com/graph/auth-v2-service?tabs=curl)
- [Microsoft Graph Bicep Extension (v1.0)](https://mcr.microsoft.com/en-us/artifact/mar/bicep/extensions/microsoftgraph/v1.0/tags)
- [Quickstart: Create and deploy your first Bicep file with Microsoft Graph resources](https://learn.microsoft.com/en-us/graph/templates/quickstart-create-bicep-interactive-mode?tabs=CLI)
- [Quickstart: Deploy a Bicep file as a service principal](https://learn.microsoft.com/graph/templates/quickstart-create-bicep-zero-touch-mode?tabs=CLI)
