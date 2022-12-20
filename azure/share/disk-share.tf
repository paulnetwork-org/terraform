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

resource "random_pet" "paul" {
  prefix = var.resource_group_name_prefix
}


resource "azurerm_resource_group" "paul" {
  name     = "paul-resources"
  location = var.location
}


resource "azurerm_kubernetes_cluster" "paul" {
  name                = "paul-k8s"
  location            = azurerm_resource_group.paul.location
  resource_group_name = azurerm_resource_group.paul.name
  dns_prefix          = "paulkube" 

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



resource "azurerm_managed_disk" "azuredisk1" {
  name                 = "azuredisk1"
  location             = azurerm_resource_group.paul.location
  resource_group_name  = azurerm_resource_group.paul.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  tags = {
    environment = azurerm_resource_group.paul.name
  }
}

# the bellow script runs after cluster is created and config imported --> az aks get-credentials --name paul --resource-group paul

provider "kubernetes" {
  config_path = "~/.kube/config"
}


resource "kubernetes_persistent_volume" "azuredisk1" {
  metadata {
    name = "azuredisk1"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "azuredisk1"
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = azurerm_managed_disk.azuredisk1.id
        disk_name     = "azuredisk1"
        kind          = "Managed"
      }
    }
  }
}



resource "kubernetes_persistent_volume_claim" "azuredisk1" {
  metadata {
    name = "azuredisk1"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "azuredisk1"
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  volume_name = "azuredisk1"
  }
}

resource "kubernetes_deployment" "website" {
  metadata {
    name = "website-deployment"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "website"
      }
    }
    template {
      metadata {
        labels = {
          app = "website"
        }
      }
      spec {
        container {
          name  = "website"
          image = "nginx:latest"
          volume_mount {
            name      = "azuredisk1"
            mount_path = "/mnt/azure"
          }
        }
        volume {
          name = "azuredisk1"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.azuredisk1.metadata.0.name
          }
        }
      }
    }
  }
}
