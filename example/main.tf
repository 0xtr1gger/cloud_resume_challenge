# example/main.tf

resource "random_string" "storage_account_suffix" {
  length  = 8
  upper   = false
  special = false
}

module "website_module" {
  source               = "../modules/static-website"
  resource_group_name  = "rg-cloud-resume-example"
  storage_account_name = format("cloudresume%s", random_string.storage_account_suffix.result)

}

#module "vm_module" {
#  source              = "../modules/azure-api-server"
#  resource_group_name = "rg-cloud-resume-example-vm"
#  rg_location         = "East Asia"
#  vm_hostname         = "cloudresumeapi"
#}