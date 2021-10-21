# Terraform activity

This repository is from an activity of the Software Engineering MBA .
Team: Rodrigo Bighetti, Gian Matheus and Estevão Fekete

## Installation

1 - Clone this repository. \
2 - Make sure you have [Azure CLI](https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli) and [Terraform CLI](https://www.terraform.io/downloads.html) \
3 - (if you need) run az login, to login in your Azure login \
4 - use "terraform init" command, to start your local terraform instance \
5 - use "terraform apply" command, to push your files to your azure account

```bash
git clone https://github.com/robighetti/terraform-azure-atividade02
```

```bash
terraform -v 
Terraform v1.0.9
on windows_amd64 # Response example (if your bash not return something like this, please install terraform cli)
```

```bash
cd terraform-azure-atividade02
terraform init
# after run and success messages 
terraform apply
```

## How do I connect to the database?

In your Workbench or other DBMS, put the following configuration: \
Server Host: your pubic ip (after the push in Azure Portal) \
Port: 3306 \
Database: mbadb \
User: mbauser \
Password: mbauser 
