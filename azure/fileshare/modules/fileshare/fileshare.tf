
provider "kubernetes" {
  config_path = "~/.kube/config"
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
