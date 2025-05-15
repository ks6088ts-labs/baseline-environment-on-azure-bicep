# AOAI Scenario

This is a scenario for the Azure Policy Assignment.

## Deploy resources on Azure

```shell
cd infra
make deploy SCENARIO=policy-assignment
```

## Destroy resources on Azure

```shell
cd infra
make destroy SCENARIO=policy-assignment
```

## References

- [Azure Policy built-in policy definitions](https://learn.microsoft.com/ja-jp/azure/governance/policy/samples/built-in-policies)
- [Azure Policy Samples](https://github.com/Azure/azure-policy)
- [azurerm_subscription_policy_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment)
- [az role assignment create](https://learn.microsoft.com/ja-jp/cli/azure/role/assignment?view=azure-cli-latest#az-role-assignment-create)
