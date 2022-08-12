terraform {
   required_providers {
   linode = {
      source = "linode/linode"
      version = "1.27.1"
      }
   }
}

provider "linode" {
  token = var.token
}

resource "linode_lke_cluster" "foobar" {
   k8s_version = "1.23"
   label = "laroa-cluster"
   region = "eu-central"
   tags = ["website"]
   
   pool {
      type = "g6-standard-4"
      count = 3
   }
}

module "kubernetes_deployment" {
  source = "./modules/website/"
}



