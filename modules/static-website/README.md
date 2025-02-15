# Terraform module for deploying a static website on Azure Blob Storage

This Terraform module is used to automate the provisioning and deployment of a static website on Azure Blob storage. It creates an Azure resource group, Blob storage account, and storage container, then uploads blobs for static files for the website into the storage container as Blbos. The website is configured to be publicly accessible. 

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.blob_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_static_website.static_website](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_static_website) | resource |
| [azurerm_storage_blob.blobs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | The name of the error document for the static website. | `string` | `"index.html"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | The name of the index document for the static website. | `string` | `"index.html"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure resource group to create. | `string` | `"rg-cloud-resume-challenge"` | no |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | The Azure region to deploy the resources. | `string` | `"East US"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The unique name for the Azure Storage Account. | `string` | n/a | yes |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The replication type for the storage account. | `string` | `"LRS"` | no |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | The tier for the Azure storage account. | `string` | `"Standard"` | no |
| <a name="input_storage_container_name"></a> [storage\_container\_name](#input\_storage\_container\_name) | The name of the Azure Blob storage container. | `string` | `"web"` | no |
| <a name="input_styles"></a> [styles](#input\_styles) | The name of the CSS file for the website. | `string` | `"styles.css"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_index_blob_url"></a> [index\_blob\_url](#output\_index\_blob\_url) | The URL of the index.html blob. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group containing the storage account. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the Azure Storage Account. |
| <a name="output_storage_account_primary_web_endpoint"></a> [storage\_account\_primary\_web\_endpoint](#output\_storage\_account\_primary\_web\_endpoint) | The primary web endpoint for the static website. |
| <a name="output_storage_container_name"></a> [storage\_container\_name](#output\_storage\_container\_name) | The name of the storage container for static files. |
