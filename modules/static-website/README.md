# Azure Blob Storage Static Website  

This Terraform module provisions a static website hosted on Azure Blob Storage. It creates an Azure resource group, storage account, storage container, then loads blobs for HTML and CSS files and deploys a static website within the container.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.blob_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_static_website.static_website](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_static_website) | resource |
| [azurerm_storage_blob.index_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.styles_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
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

## Example

```
module "azure_static_website" {
    source               = "./modules/static-website"
    storage_account_name = "unique_storage_account_name" # required
    resource_group_name  = "custom-resource-group-name"
    rg_location          = "West US"
    # other input variables ...
}
```