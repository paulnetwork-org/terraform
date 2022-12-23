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


output "client_certificate" {
  value     = azurerm_kubernetes_cluster.test2.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.test2.kube_config_raw

  sensitive = true
}


provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.test2.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.test2.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.test2.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.test2.kube_config.0.cluster_ca_certificate)
}

module "kubernetes_deployment" {
  source = "./modules/nginx/"
}

