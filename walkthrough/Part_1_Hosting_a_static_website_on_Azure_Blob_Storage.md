# Part 1: Hosting a static website on Azure Blob Storage

## Introduction

Welcome to the first part of my walkthrough for the Cloud Resume Challenge! 
In this section, we will explore the process of creating a static website to host an HTML resume on Azure Blob Storage, utilizing Terraform for Infrastructure as Code (IaC).
- [Navigation](https://github.com/0xtr1gger/cloud_resume_challenge)

#### What to expect

Before we begin, it's beneficial to have a basic understanding of Terraform and Azure services.

Here’s a brief overview of what we will accomplish in this part:

- Installing tools
	- We will begin by installing the necessary tools for the project—Terraform and the Azure CLI.

- Creating a static web page
	- Next, we will create an HTML page with the resume itself and a corresponding CSS file to style it a bit.

- Provisioning resources
	- The heart of this walkthrough involves writing and applying Terraform configurations that will automatically set up required Azure resources, including an Azure Resource Group, a Storage Account, and a Blob Container, followed by deploying the HTML page page on Azure Blob Storage.

This part of the challenge is not difficult, but serves as a good starting point for hands-on practice with Terraform and Azure. 

Let’s get started!

#### Table of content

- Introduction
	- What to expect
	- Table of content
	- Technologies used

- Prerequisites: installing Terraform and Azure CLI
	- Installing Terraform
		- For Debian & Ubuntu
		- For Arch-based distributions
	- Installing Azure CLI
- Dealing with HTML/CSS
- Provisioning cloud infrastructure with Terraform
- Applying the configuration
- Conclusion

#### Technologies used

- Terraform
- Azure CLI
- Azure Blob Storage

>*Note: This lab assumes Linux as a working machine.* 

## Prerequisites: installing Terraform and Azure CLI
### Installing Terraform

The first step is to download and install [Terraform](https://www.terraform.io/), an open-source IaC tool that automates the configuration, management, and provisioning of cloud infrastructure.

Terraform is available as a package in many Linux distributions, including Debian and Arch. Follow the official documentation for detailed installation instructions.

- [Documentation: Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
#### For Debian & Ubuntu

On Debian-based distributions, including Ubuntu and Debian, Terraform can be installed from the official HashiCorp package repository.

1. Ensure necessary packages are installed

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

2. Install the HashiCorp [GPG key](https://apt.releases.hashicorp.com/gpg "HashiCorp GPG key"):

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

3. Verify the key's fingerprint:

```bash
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

4. Add the HashiCorp repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

5. Install Terraform:

```bash
sudo apt update && sudo apt-get install terraform
```

6. Verify the installation

```bash
terraform --version
```
#### For Arch-based distributions

As for me, I use Manjaro to work on DevOps projects like this one.
On Arch-based Linux distributions, including Manjaro and Arch Linux, Terraform is available as a Pacman software [package](https://archlinux.org/packages/extra/x86_64/terraform/), and the installation process requires only a single command.

1. Install Terraform as a Pacman package

```bash
sudo pacman -S terraform
```

2. Verify the installation

```bash
terraform --version
```

### Installing Azure CLI

Another essential tool for this project is [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/), a tool for working with Azure and managing cloud services from the command line. 

Azure CLI is available on various Linux distributions, including Debian-, RPM-, and Arch-based ones. 

- [Documentation: How to install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

The tool can be installed with a single command, which triggers an execution of a Bash script created by Microsoft:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

On an Arch-based system, Azure CLI is also available on AUR:

```bash
git clone https://aur.archlinux.org/python-azure-cli.git && cd python-azure-cli && makepkg -si
```

Alternatively, you can run Azure CLI in a Docker container:

```bash
docker run -it mcr.microsoft.com/azure-cli
```

To verify the installation:

```bash
az --version
```

## Dealing with HTML/CSS

Creating a static web page is straightforward. All that's necessary is a simple HTML file coupled with some CSS for styling. Although JavaScript could enhance the interactivity of the website, it's not necessary at this initial stage; it may come into play in future parts of the project, namely, for querying the visitor counter API.

Here is a list of helpful resources to learn the basics of HTML, CSS, and JavaScript:

- [`W3schools: HTML`](https://www.w3schools.com/html/html_intro.asp)
- [`freeCodeCamp: HTML Full Course — Build a Website Tutorial`](https://www.youtube.com/watch?v=pQN-pnXPaVg)
- [`freeCodeCamp: Learn HTML and CSS with this free 11 hour course`](https://www.freecodecamp.org/news/html-css-11-hour-course/)
- [`CSS Tricks`](https://css-tricks.com/)
- [`web.dev by Google — Learn CSS`](https://web.dev/learn/css/)
- [`The Modern JavaScript Tutorial`](https://javascript.info/)

The project structure for the static website should look like this:

```bash
tree -L .
```
```
.
├── README.md
├── src
│   └── static
│       ├── index.html
│       └── styles.css
```

You may want to take a look into the template of an HTML/CSS CV given in this repository:

- [`index.html`]
- [`styles.css`]


## Provisioning cloud infrastructure with Terraform

With the web page ready, it’s time to set up Azure Blob Storage. While this can be done via the Azure portal, implementing Infrastructure as Code (IaC) from the onset is a best practice that brings a host of advantages — repeatability, greater visibility, and efficiency.

>Azure also offers its own proprietary service called [ARM (Azure Resource Manager)](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview "null") for implementing IaC. However, it is primary designed to be used with Azure, and to manage other cloud resources with it, say, AWS, additional setup is required. Conversely, Terraform is open-source and has robust community support, making it the preferred IaC tool across many industries.

Terraform configurations consist of `.tf` files written in the HashiCorp Configuration Language (HCL). Files related to a specific project or a part thereof are placed into a separate directory and collectively referred to as a module.

In this project, we will create two Terraform modules, but this part only focuses on the first one.

First, create a directory called `terraform`, and a subdirectory for the website configuration module, called `static_website`. 

The project structure will look like this:

```
.
├── README.md
├── src
│   └── static
│       ├── index.html
│       └── styles.css
└── terraform
    └── static_website
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

Here is an overview of the configuration files:

- `main.tf`
	- The primary configuration file where all the resource definitions reside.

- `variables.tf`
	- This file will contain the Terraform variables.
	- Variables allow the configuration to be reusable and keep it well-organized, avoiding hard-coded values in resource declaration blocks.

- `outputs.tf`
	- This file declares output variables, i.e., the values that Terraform will display upon completion of the `terraform apply` operation.

>It is possible to place all the configuration blocks, including resource definitions, input variables, and output variables, into a single file, say, `main.tf`. However, managing such configuration becomes challenging as the infrastructure becomes more complex; therefore, this solution is impractical for scalability and portability. 
>This is why it is better to split Terraform configuration into several files.

- The Terraform provider for working with Azure is called [`azurerm`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs). Its source code is available [here](https://github.com/hashicorp/terraform-provider-azurerm).

### `main.tf`

We will start with the file called `main.tf` in the `terraform/static_website` directory. The whole configuration looks like this:

```Python
terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cloud-resume-challenge"
  location = "East US"
}

resource "azurerm_storage_account" "blob_storage" {
  name                     = var.azure_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.blob_storage.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

resource "azurerm_storage_container" "container" {
  name                  = "web"
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "container"
}

resource "azurerm_storage_blob" "index_blob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../src/static/index.html"
  content_type           = "text/html"
	content_md5            = md5(file("${path.module}/../../src/static/index.html"))
}

resource "azurerm_storage_blob" "styles_blob" {
  name                   = "styles.css"
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../src/static/styles.css"
	content_type					 = "text/css"
	content_md5            = md5(file("${path.module}/../../src/static/styles.css"))
}
```

We will take it apart and inspect every configuration block one-by-one.
#### The `terraform` block and Azure provider 

1. We initiate our configuration with the following blocks:

```Python
terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

- The `terraform` block is used to define provider-specific configuration. 
	- `required_version` 
		- The minimum Terraform version required for the project. 
	- `required_providers` 
		- The providers that this Terraform module makes use of.

- `azurerm` block configures the Azure Terraform provider
	- `source`
		- The source from which Terraform can download the provider plugin.
	- `version` 
		- The version of the provider the project requires.  

- The `provider` block can be used to further configure `azurerm`.
#### Azure resource group

2. Next, we define a Resource Group object with `azurerm_resource_group`:
	- Documentation: [`azurerm_resource_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

```Python
resource "azurerm_resource_group" "rg" {
  name     = "rg-cloud-resume-challenge"
  location = "East US"
}
```


- `name` 
	- A name for the resource group, in this case, `rg-cloud-resume-challenge`. 
	- The name for the Resource Group must be unique within an Azure subscription. 

- `location`
	- The Azure region where the Resource Group will be created.
	- All resources within a Resource Group must reside in the same region as the Resource Group itself.

>An Azure Resource Group is a logical grouping of Azure resources that facilitates management and organization of resources based on their functionality.  
>It is recommended to create a separate Resource Group for each project. 
>Additionally, it is worth mentioning that Resource Groups are free: you can create as many of them as you wish without worrying about charges.
#### Azure storage account

3. We will store our static website in an Azure Storage Account managed with `azurerm_storage_account`:
	- Documentation: [`azurerm_storage_account`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

```Python
resource "azurerm_storage_account" "blob_storage" {
  name                     = var.azure_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

- `name`
	- A unique name of an Azure storage account. Must only consist of 3-24 lowercase alphanumeric characters.
	- The `var.azure_storage_account_name` refers to a Terraform input variable with the name `azure_storage_account_name` specified in the configuration of the same Terraform module. It will be defined later.

- `resource_group_name` 
	- The name of the resource group this Storage Account is tied to.

- `location`
	- The Azure location where the Storage Account exists. Here, the same as the resource group region.

- `account_tier`
	- The Tier of this storage account. 
	- Azure defines several Tiers for storage accounts, with the Standard General Purpose v2 (GPv2) Storage Account being the most popular, as it supports all storage services and suitable for most applications. 

- `account_replication_type`
	- The type of replication used for this storage account. 
	- LRS means Locally Redundant Storage. With this replication strategy, Azure keeps multiple copies of data within a single data center. There are other replication strategies as well. 

>An Azure Storage Account is a unique namespace within Azure that provides a unified endpoint for accessing various Azure Storage services, including blobs, files, queues, tables, and disk storage. 

- Each Azure Storage Account must have a unique name across Azure.  
- Every object stored in an Azure Storage service has an address that includes that Storage Account name. 
- The combination of the account name and the Blob Storage endpoint forms the base address for the objects in a storage account.
#### Azure storage container and static website hosting

4. To enable static website hosting, we add the static website resource with `azurerm_storage_account_static_website`:
	- Documentation: [`azurerm_storage_account_static_website`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_static_website)

```Python

resource "azurerm_storage_container" "container" {
  name                  = "web"
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "container"
}

```

- `storage_account_name`
	- The name of the Storage Account to set the Static Website on. 
	- In this case, it refers to the `name` attribute of the `blob_storage` object. 

- `index_dument`
	- The web page that Azure Storage will serve for requests to the root of a website.

- `error_document`
	- The web page that will be served for `404 Not Found` responses. It is optional, but useful for custom 404 pages.

>An Azure Storage Container represents a logical grouping or namespace for BLOBs (Binary Large Objects) in Azure Blob Storage. Similar to how Resource Groups arrange any resources created in Microsoft Azure, Azure Storage Containers organize Blobs. They can be thought of as folders inside an Azure Blob Storage. 

>Blobs, essentially, allow users to store unstructured data, including web pages, various scripts, images, and so on. 

#### Azure Blob resources

5. Next, we create a blob container within a Storage Account where all the files will reside, using `azurerm_storage_container`:
	- Documentation: [`azurerm_storage_container`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)

```Python
resource "azurerm_storage_container" "container" {
  name                  = "web"                         # Name of the container
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "container"                     # Container access level
}
```

- `name`
	- The name of the Container to be created within the Storage Account.

- `storage_account_name`
	- The name of the Storage Account where the Container Should be created. 

- `container_access_type`
	- The Access Level configured for this Container. Possible values are `blob`, `container` or `private`. Defaults to `private`.
	- Here are the option that can be specified here:
	
		- `private`
			- Requires authorization to access both the Container and the blobs stored within. 
		- `blob`
			- Anonymous read access is allowed for blobs only. Users can read blob data without authentication, but cannot access container metadata or list blobs within the Container.
		- `container`
			- Anonymous read access is allowed for Containers and blobs. Users can read Container metadata, list blobs, and read blob data without authentication.

	- Here, `container` allows the website to be accessed by anyone without authentication. Perfect for a publicly available static website.

>A Container is a hierarchical structure that organizes a set of blobs, similar to how a directory is used to organize a set of files.

- Containers are used to organize and manage blobs more easily. Without containers, blobs would reside in a Storage Container without any logical grouping.

- Access controls can be enforced on the Container level and applied to every blob in it instead of separately for each blob. This further simplifies the management process.

- A Storage Account can include any number of containers, and each Container can store any number of blobs. However, containers cannot be nested.

- A container name must be a valid DNS name, as it forms part of the unique URI (Unique Resource Identifier) used to locate the container and blobs within. 
	- Briefly, the requirements to the Container name are as follows: 
		- Must be 3-63 character long, inclusively.
		- Must begin with an alphanumeric character.
		- Must only contain lowercase alphanumeric characters and dash characters.
		- Must not contain two or more consecutive dash characters.
#### Creating Blobs

6. Lastly, we define the storage blobs for HTML and CSS files using the `azurerm_storage_blob` resource:
	- Documentation: [`azurerm_storage_blob`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob)

```bash
resource "azurerm_storage_blob" "index_blob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../src/static/index.html"
  content_type           = "text/html"
  content_md5            = md5(file("${path.module}/../../src/static/index.html"))
}

```

- The `azurerm_storage_blob` resource type is used to create Blobs in a Blob container and upload files to it.

- `name`
	- The name of the storage Blob. 
	
	- Must be unique within the Storage Container in which the Blob is created (same as files in the same folder must have unique names within that folder).

- `storage_account_name`
	- The name of the Storage Account in which to create the Blob.

- `storage_container_name`
	- The name of the Storage Container in which to create the Blob.

- `type`
	- The type of the storage Blob to be created. Can be `Append`, `Block`, or `Page`. 

- `source`
	- An absolute path to a file on the local system.

- `content_type`
	- The content type of the storage blob. 

	- This should be set to `text/html` so that files serve as web pages. Otherwise, upon trying to access a blob by its URL, the blob file will be downloaded to a local system instead of being displayed as a web page in a browser tab, even if all permissions have been correctly set.

- `content_md5`
	- The MD5 hash dynamically calculated based on the Blob content. 

	- When a file's content changes, we want Terraform to update the website accordingly, i.e., create a new version of a blob and delete the previous one (following the immutable infrastructure paradigm). The `content_md5` hash serves as an indicator of such changes, and is calculated anew on each run of `terraform plan`/`apply`. 
	
	- If the hash is the same, it means the content of the file hasn't been changed; otherwise, the blob requires substitution to reflect modifications.

	- The `md5()` function dynamically calculates the hash of the file referenced by the `file()` function each time `terraform plan` or `terraform apply` commands are run. 

	- Without this parameter, Terraform will only initially create the file, but subsequent changes to it will not be reflected in the infrastructure.

As you may have noticed, each file requires a separate blob. The block described above manages the blob for the `index.html` file. 
To manage the CSS file, another blob should be created using an `azurerm` block of a similar structure:

```Python
resource "azurerm_storage_blob" "styles_blob" {
  name                   = "styles.css"
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../src/static/styles.css"
	content_type					 = "text/css"
	content_md5            = md5(file("${path.module}/../../src/static/styles.css"))
}
```
### `variables.tf`

For convenience and re-usability, it is better to introduce variables into Terraform configuration, instead of hard-coding values into `main.tf` directly. 
Below is the `variables.tf` file, specifically intended for variable declaration:

```Python
variable "azure_storage_account_name" {
  type        = string
  description = "The name for the Azure Storage Account"
  default     = "unique-azure-storage-account-name"
}
```

Here, we only create one variable, for the name of the storage account. 

- `type`
	- The type of the variable.
- `description`
	- An optional, but recommended description of the variable, explaining its purpose. 
- `default`
	- An optional default value for the variable. This is the place where the desired Storage Account name should be put. 

### `outputs.tf`

The last file, `outputs.tf`, will articulate what Terraform returns after applying the configuration. In other works, it defines output variables for the module.

```Python
output "resource_group_name" {
  description = "The name of the resource group containing the storage account."
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = azurerm_storage_account.blob_storage.name
}

output "storage_account_primary_web_endpoint" {
  description = "The primary web endpoint for the static website."
  value       = azurerm_storage_account.blob_storage.primary_web_endpoint
}

output "storage_container_name" {
  description = "The name of the storage container for static files."
  value       = azurerm_storage_container.container.name
}

output "index_blob_url" {
  description = "The URL of the index.html blob."
  value       = "${azurerm_storage_account.blob_storage.primary_web_endpoint}${azurerm_storage_container.container.name}/index.html"
}
```

## Applying the configuration

After all configuration files are written, it's time to initialize and apply them.

1. Initialize Terraform:

```bash
terraform init
```

![terraform_init](https://github.com/user-attachments/assets/90f56870-3deb-4894-8d85-e3bae83cfded)


2. Create an Execution Plan:

```bash
terraform plan
```
![terraform_plan](https://github.com/user-attachments/assets/c8f8ef36-de86-400a-8e12-dbe5c4b1a948)


3. Apply the Configuration:

```bash
terraform apply
```
![terraform_apply](https://github.com/user-attachments/assets/a43eda0b-b877-4d8b-88db-c1ea5500cfc6)


Once applied, the website should be accessible through the URL of the following format:

```bash
https://<storage_account_name>.blob.core.windows.net/<container_name>/<blob_name>
```

We can also check the resources using the Azure CLI:

```bash
az storage blob list --account-name <storage_account_name> --container-name web -o table
```

```
Name        Blob Type    Blob Tier    Length    Content Type    Last Modified              Snapshot
----------  -----------  -----------  --------  --------------  -------------------------  ----------
index.html  BlockBlob    Hot          47086     text/html       2024-12-04T14:54:03+00:00
styles.css  BlockBlob    Hot          8917      text/css        2024-12-04T14:54:03+00:00
```

Notice that if we modify any of the files stored in the blobs, `index.html` or `styles.css`, Terraform will implement the changes on the next `terraform apply`. The output will look like this:

![terraform_replace](https://github.com/user-attachments/assets/a47d1022-1ea1-4f60-aedd-c604a5cd3c0a)


## Conclusion

With this guide, you now have the foundational knowledge to host a static website on Azure using Terraform! 

In the next part, we will move the project to GitHub and create a CI/CD workflow with GitHub actions to automate updates to the website each time the contents in the repository changes. The last part will be dedicated for an Azure VM hosting a small Flask API. 

Happy coding!

