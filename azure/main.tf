terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.17.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "kubernetes_deployment" {
  source = "./modules/website/"
}

#module "mysql" {
#  source = "./modules/mysql/"
#}

