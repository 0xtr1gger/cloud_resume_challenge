# example/main.tf

resource "random_string" "storage_account_suffix" {
  length  = 8
  upper   = false
  special = false
}

module "website_module" {
  source               = "../../modules/static-website"
  source_code_path     = "../../src/static/"
  resource_group_name  = "rg-cloud-resume-example"
  storage_account_name = format("cloudresume%s", random_string.storage_account_suffix.result)

}