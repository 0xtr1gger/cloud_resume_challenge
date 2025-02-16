# Root module for the static website


This module deploys a [static website](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/src/static) on Azure by calling the [`static-website`](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/modules/static-website) module. It also defines a remote Terraform backend.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_website_module"></a> [website\_module](#module\_website\_module) | ../modules/static-website | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.storage_account_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_index_blob_url"></a> [index\_blob\_url](#output\_index\_blob\_url) | The URL of the index.html blob. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group containing the storage account. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the Azure Storage Account. |
