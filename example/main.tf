# example/main.tf

terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "website_module" {
	source               = "../modules/static-website"
	storage_account_name = "unique_storage_account_name"
}