## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.api_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.vm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.nsg_vm_nic_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.api_vm_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.vm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.vm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nsg_config"></a> [nsg\_config](#input\_nsg\_config) | n/a | <pre>object({<br/>    name = string<br/><br/>    security_rules = list(object({<br/>      name     = string<br/>      priority = number<br/><br/>      direction = string<br/>      access    = string<br/>      protocol  = string<br/><br/>      source_port_range      = string<br/>      destination_port_range = string<br/><br/>      source_address_prefix      = string<br/>      destination_address_prefix = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "name": "api_vm_nsg",<br/>  "security_rules": [<br/>    {<br/>      "access": "Allow",<br/>      "destination_address_prefix": "*",<br/>      "destination_port_range": "22",<br/>      "direction": "Inbound",<br/>      "name": "allow-SSH",<br/>      "priority": 100,<br/>      "protocol": "Tcp",<br/>      "source_address_prefix": "*",<br/>      "source_port_range": "*"<br/>    },<br/>    {<br/>      "access": "Allow",<br/>      "destination_address_prefix": "*",<br/>      "destination_port_range": "80",<br/>      "direction": "Inbound",<br/>      "name": "allow-HTTP-API",<br/>      "priority": 200,<br/>      "protocol": "Tcp",<br/>      "source_address_prefix": "*",<br/>      "source_port_range": "*"<br/>    },<br/>    {<br/>      "access": "Deny",<br/>      "destination_address_prefix": "*",<br/>      "destination_port_range": "22",<br/>      "direction": "Inbound",<br/>      "name": "deny-all-inbound",<br/>      "priority": 300,<br/>      "protocol": "*",<br/>      "source_address_prefix": "*",<br/>      "source_port_range": "*"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure resource group to create. | `string` | `"rg-cloud-resume-challenge-vm"` | no |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | The Azure region to deploy the resources. | `string` | `"East US"` | no |
| <a name="input_ssh_public_key_file"></a> [ssh\_public\_key\_file](#input\_ssh\_public\_key\_file) | Path to the SSH public key file. | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_vm_admin_username"></a> [vm\_admin\_username](#input\_vm\_admin\_username) | Username of the administrator account to create on Azure VM | `string` | `"ansible"` | no |
| <a name="input_vm_config"></a> [vm\_config](#input\_vm\_config) | n/a | <pre>object({<br/>    name = string<br/>    size = string<br/>    os_disk = object({<br/>      name                 = string<br/>      caching              = string<br/>      storage_account_type = string<br/>    })<br/>    source_image_reference = object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "name": "api_vm",<br/>  "os_disk": {<br/>    "caching": "ReadWrite",<br/>    "name": "api_vm_os_disk",<br/>    "storage_account_type": "Standard_LRS"<br/>  },<br/>  "size": "Standard_B2ts_v2",<br/>  "source_image_reference": {<br/>    "offer": "0001-com-ubuntu-server-jammy",<br/>    "publisher": "Canonical",<br/>    "sku": "22_04-lts-gen2",<br/>    "version": "latest"<br/>  }<br/>}</pre> | no |
| <a name="input_vm_hostname"></a> [vm\_hostname](#input\_vm\_hostname) | Hostname for the Azure VM | `string` | `"hostname"` | no |
| <a name="input_vm_nic_config"></a> [vm\_nic\_config](#input\_vm\_nic\_config) | n/a | <pre>object({<br/>    name = string<br/><br/>    ip_configuration = object({<br/>      name                          = string<br/>      private_ip_address_allocation = string<br/>    })<br/><br/>    public_ip = object({<br/>      name              = string<br/>      allocation_method = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "ip_configuration": {<br/>    "name": "api_vm_nic_configuration",<br/>    "private_ip_address_allocation": "Dynamic"<br/>  },<br/>  "name": "api_vm_nic",<br/>  "public_ip": {<br/>    "allocation_method": "Dynamic",<br/>    "name": "api_vm_public_ip"<br/>  }<br/>}</pre> | no |
| <a name="input_vnet_config"></a> [vnet\_config](#input\_vnet\_config) | n/a | <pre>object({<br/>    name          = string<br/>    address_space = list(string)<br/>    subnet = object({<br/>      name             = string<br/>      address_prefixes = list(string)<br/>    })<br/>  })</pre> | <pre>{<br/>  "address_space": [<br/>    "10.0.0.0/16"<br/>  ],<br/>  "name": "api_vm_vnet",<br/>  "subnet": {<br/>    "address_prefixes": [<br/>      "10.0.1.0/24"<br/>    ],<br/>    "name": "api_vm_subnet"<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
