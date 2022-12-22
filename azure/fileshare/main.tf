terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.36.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test2" {
  name     = "test2"
  location = "westeurope"
}


resource "azurerm_kubernetes_cluster" "test2" {
  name                = "test2"
  location            = azurerm_resource_group.test2.location
  resource_group_name = azurerm_resource_group.test2.name
  dns_prefix          = "k8s" 

  default_node_pool {
    name           = "nodes"
    node_count     = 2
    vm_size        = "Standard_D2_v3"
    os_sku         = "Ubuntu"
  }

    linux_profile {
    admin_username = "azure_ubuntu"
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


resource "kubernetes_persistent_volume_claim" "azurefile" {
  metadata {
    name = "azurefile"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = "azurefile"
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          volume_mount {
            name      = "azurefile"
            mount_path = "/mnt/azure"
          }
        }
        volume {
          name = "azurefile"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.azurefile.metadata.0.name
          }
        }
      }
    }
  }
}
