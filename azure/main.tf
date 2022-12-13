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

resource "random_pet" "paul" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "paul" {
  name     = "paul"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "paul" {
  name                = "paul"
  location            = azurerm_resource_group.paul.location
  resource_group_name = azurerm_resource_group.paul.name
  dns_prefix          = "paul" 

  default_node_pool {
    name           = "nodes"
    node_count     = 2
    vm_size        = "Standard_D2_v3"
    
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

module "kubernetes_deployment" {
  source = "./modules/website/"
}

