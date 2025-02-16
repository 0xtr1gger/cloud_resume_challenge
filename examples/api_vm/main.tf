# example_vm/main.tf

resource "azurerm_resource_group" "rg" {
  name     = "rg-cloud-resume-example-vm"
  location = "East Asia"
}

module "vm_module" {
  source              = "../../modules/azure-api-server"
  resource_group_name = "rg-cloud-resume-example-vm"
  rg_location         = "East Asia"
  vm_hostname         = "cloudresumeapi"
  ssh_public_key_file = "./id_rsa.pub"
}