output "public_ip_address" {
  value = azurerm_linux_virtual_machine.api_vm.public_ip_address
  description = "The IP address of the provisioned VM."
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
  description = "The name of the resource group where the resources reside."
}

output "vm_hostname" {
  value = azurerm_linux_virtual_machine.api_vm.computer_name
  description = "The hostname of the provisioned VM."
}