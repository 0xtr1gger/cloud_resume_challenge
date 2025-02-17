variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group to create."
  default     = "rg-cloud-resume-challenge-vm"
}

variable "rg_location" {
  type        = string
  description = "The Azure region to deploy the resources."
  default     = "East US"
}

variable "vm_admin_username" {
  type        = string
  description = "Username of the administrator account to create on Azure VM"
  default     = "ansible"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Path to the SSH public key file."
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_hostname" {
  type        = string
  description = "Hostname for the Azure VM"
  default     = "hostname"
}

variable "vnet_config" {
  type = object({
    name          = string
    address_space = list(string)
    subnet = object({
      name             = string
      address_prefixes = list(string)
    })
  })
  default = {
    name          = "api_vm_vnet"
    address_space = ["10.0.0.0/16"]
    subnet = {
      name             = "api_vm_subnet"
      address_prefixes = ["10.0.1.0/24"]
    }

  }
}


variable "vm_nic_config" {
  type = object({
    name = string

    ip_configuration = object({
      name                          = string
      private_ip_address_allocation = string
    })

    public_ip = object({
      name              = string
      allocation_method = string
    })
  })

  default = {
    name = "api_vm_nic"

    ip_configuration = {
      name                          = "api_vm_nic_configuration"
      private_ip_address_allocation = "Dynamic"
    }

    public_ip = {
      name              = "api_vm_public_ip"
      allocation_method = "Dynamic"
    }
  }
}


variable "nsg_config" {
  type = object({
    name = string

    security_rules = list(object({
      name     = string
      priority = number

      direction = string
      access    = string
      protocol  = string

      source_port_range      = string
      destination_port_range = string

      source_address_prefix      = string
      destination_address_prefix = string
    }))
  })

  default = {
    name = "api_vm_nsg"
    security_rules = [
      {
        name     = "allow-SSH"
        priority = 100

        direction = "Inbound"
        access    = "Allow"
        protocol  = "Tcp"

        source_port_range      = "*"
        destination_port_range = "22"

        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name     = "allow-HTTP-API"
        priority = 200

        direction = "Inbound"
        access    = "Allow"
        protocol  = "Tcp"

        source_port_range      = "*"
        destination_port_range = "80"

        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name     = "deny-all-inbound"
        priority = 300

        direction = "Inbound"
        access    = "Deny"
        protocol  = "*"

        source_port_range      = "*"
        destination_port_range = "22"

        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

variable "vm_config" {
  type = object({
    name = string
    size = string
    os_disk = object({
      name                 = string
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  })

  default = {
    name = "api_vm"
    size = "Standard_B2ts_v2"

    os_disk = {
      name                 = "api_vm_os_disk"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
  }
}