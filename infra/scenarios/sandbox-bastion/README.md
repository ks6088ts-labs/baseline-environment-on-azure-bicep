# Sandbox environment with bastion host

This is a scenario for a sandbox environment with a bastion host.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=sandbox-bastion
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=sandbox-bastion
```

## References

- [Azure OpenAI Service のロールベースのアクセス制御](https://learn.microsoft.com/ja-jp/azure/ai-services/openai/how-to/role-based-access-control)
- [マネージド ID を使用して Azure OpenAI Service を構成する方法](https://learn.microsoft.com/ja-jp/azure/ai-services/openai/how-to/managed-identity)
