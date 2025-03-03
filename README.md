# Terraform & Azure Lab: The Cloud Resume Challenge

Welcome to my [Cloud Resume Challenge](https://cloudresumechallenge.dev/) project! 

Technologies used:
- Azure
- Terraform
- Ansible
- Python
- MongoDB
- Docker
- Docker Compose
- GitHub Actions
- Nginx
- Prometheus
- Grafana

The structure of the project:
![cover](https://github.com/user-attachments/assets/25ea1746-3b42-4962-b3a7-6b45f91aa8ac)



This repository contains files and configurations that I created on my way of taking the challenge. 
This includes:
#### Static website, Terraform remote state, and CI/CD for the website
- A static website with a CV template
- [Reusable Terraform module](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/modules/static-website) that provisions all necessary Azure resources to deploy the website on Azure Blob Storage
	- The link to the website: [Cloud Resume](https://cloudresumenr5lobnx.blob.core.windows.net/web/index.html)
- The [root module](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/examples/static_website) responsible for the static website
- A [reusable module for remote Terraform state](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/modules/remote-tfstate) on Azure Blob storage
	- This module creates an Azure container to store the remote Terraform state, later used in the CI/CD (Continuous Integration/Continuous Delivery) pipeline
- The [root module](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/examples/state) that provision the container for the remote Terraform state
- A [GitHub Actions workflow](https://github.com/0xtr1gger/cloud_resume_challenge/blob/main/.github/workflows/static_website.yml) that automatically updates the website in accord with the [code](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/src/static) of the website in this repository, triggered on push
#### Azure Virtual Machine for the API, Ansible role, and CI/CD
- [Flask API](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/src/api-server) for website visitor counter + Dockerfile for it
- A [GitHub Actions workflow](https://github.com/0xtr1gger/cloud_resume_challenge/blob/main/.github/workflows/docker_builds.yml) that automatically builds Docker containers each time Python code updates
- [Reusable Terraform module](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/modules/azure-api-server) that creates a virtual machine and all necessary resources for it
- The [root module](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/examples/api_vm) that provisions the VM (Virtual Machine)
- An [Ansible role](https://github.com/0xtr1gger/cloud_resume_challenge/tree/main/roles/api-setup) to automatically configure the VM and start Docker Containers inside of it. It is invoked by [the playbook](https://github.com/0xtr1gger/cloud_resume_challenge/blob/main/playbook.yml) in the root of this repository
- A [GitHub Actions workflow](https://github.com/0xtr1gger/cloud_resume_challenge/blob/main/.github/workflows/api_setup.yml) that automates the provisioning and set up of the VM

>This workflow will only work if you don't set up HTTPS. 

If you want to configure certificates, you first need to **configure your DNS record with the IP address of the VM**, but the problem is that you can't know this address in advance (unless you keep it reserved in Azure and import to Terraform state). For this reason, I created two separate workflows out of the above one:
- [Workflow to provision the VM](https://github.com/0xtr1gger/cloud_resume_challenge/blob/main/.github/workflows/terraform_api_setup.yml)
- (Here you should set up DNS record)
- [Workflow to set up the API on the VM](https://github.com/0xtr1gger/cloud_resume_challenge/blob/main/.github/workflows/ansible_api_setup.yml)
#### Prometheus and Grafana

Upcoming:
- Ansible role that starts and configures Node Exporter, Prometheus, and Grafana on the VM. Only Grafana is exposed to the Internet, and it should be protected with a strong password.

>**Important note:**
>Please be aware that this repository does not include my real CV for the sake of data privacy, just a CV template. However, all code and documentation accurately reflect the efforts and methodologies I applied during the challenge.


