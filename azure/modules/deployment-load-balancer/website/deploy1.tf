provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "paul-deployment"
    labels = {
      app = "website"
    }
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
          image = "pauldualsim/paulnetwork.org:latest"
          name  = "nginx"
          port {
            name = "http"
            container_port = 80
          }
          port {
            name = "https"
            container_port = 443
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = "paul-service"
  }

  spec {
    selector = {
      app = "website"
    }
    port {
      name = "http"
      port = 80
      target_port = 80
    }
    port {
      name = "https"
      port = 443
      target_port = 443
    }

    type = "LoadBalancer"
  }
}
