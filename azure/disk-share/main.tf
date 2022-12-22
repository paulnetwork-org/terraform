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

resource "azurerm_resource_group" "paul" {
  name     = "paul"
  location = var.location
}


resource "azurerm_kubernetes_cluster" "paul" {
  name                = "paul"
  location            = azurerm_resource_group.paul.location
  resource_group_name = azurerm_resource_group.paul.name
  dns_prefix          = "k8s" 

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
  storage_account_type = "Premium_LRS" # Currently shared disk only available with premium SSD 
  create_option        = "Empty"
  disk_size_gb         = "1"
  max_shares           = "2"
  tags = {
    environment = azurerm_resource_group.paul.name
  }
}


provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.test2.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.test2.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.test2.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.test2.kube_config.0.cluster_ca_certificate)
}


resource "kubernetes_persistent_volume" "azuredisk1" {
  metadata {
    name = "azuredisk1"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    storage_class_name = "azuredisk1"
    volume_mode   = "Filesystem"
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
    access_modes = ["ReadWriteMany"]
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
    replicas = 2
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
