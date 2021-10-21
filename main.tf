terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "impactaES22Atividade02" {
  name     = "impactaES22Atividade02"
  location = "eastus"

  tags = {
    "Environment" = "Atividade 02"
  }
}
