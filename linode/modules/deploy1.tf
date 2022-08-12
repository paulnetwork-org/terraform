
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "laroa-deployment"
    labels = {
      app = "website"
    }
  }

  spec {
    replicas = 3

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
          image = "pauldualsim/laroa:nginx"
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
    name = "laroa-service"
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

