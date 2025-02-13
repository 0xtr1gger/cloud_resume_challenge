# example_vm/main.tf

resource "azurerm_resource_group" "rg" {
  name     = "rg-cloud-resume-example-vm" # "rg-cloud-resume-example-vm"
  location = "East Asia"                  # "East US"
}

module "vm_module" {
  source              = "../modules/azure-api-server"
  resource_group_name = "rg-cloud-resume-example-vm" # "rg-cloud-resume-example-vm"
  rg_location         = "East Asia"
  vm_hostname         = "cloudresumeapi"
}
