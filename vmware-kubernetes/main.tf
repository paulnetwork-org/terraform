terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.3.1"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere-user
  password       = var.vsphere-password
  vsphere_server = var.vsphere-vcenter
  
  # If you have a self-signed cert
  allow_unverified_ssl = var.vsphere-unverified-ssl
}


module "kube-master" {
  source = "./kube-master"
  providers = {
    vsphere = vsphere
  }  
  vsphere-vcenter = var.vsphere-vcenter
  vsphere-user = var.vsphere-user
  vsphere-password = var.vsphere-password
  vsphere-unverified-ssl = var.vsphere-unverified-ssl
  vsphere-datacenter = var.vsphere-datacenter
  vm-domain = var.vm-domain
  vsphere-template-folder = var.vsphere-template-folder
  vm-template-name = var.vm-template-name
  vm-network = var.vm-network
  vm-guest-id = var.vm-guest-id
  vm-adapter_type = var.vm-adapter_type
  linux_pass = var.linux_pass
}

module "kube-node1" {
  source = "./kube-node1"
  providers = {
    vsphere = vsphere
  }  
  depends_on = [module.kube-master]
  vsphere-vcenter = var.vsphere-vcenter
  vsphere-user = var.vsphere-user
  vsphere-password = var.vsphere-password
  vsphere-unverified-ssl = var.vsphere-unverified-ssl
  vsphere-datacenter = var.vsphere-datacenter
  vm-domain = var.vm-domain
  vsphere-template-folder = var.vsphere-template-folder
  vm-template-name = var.vm-template-name
  vm-network = var.vm-network
  vm-guest-id = var.vm-guest-id
  vm-adapter_type = var.vm-adapter_type
  linux_pass = var.linux_pass
}

module "kube-node2" {
  source = "./kube-node2"
  providers = {
    vsphere = vsphere
  }  
  depends_on = [module.kube-master]
  vsphere-vcenter = var.vsphere-vcenter
  vsphere-user = var.vsphere-user
  vsphere-password = var.vsphere-password
  vsphere-unverified-ssl = var.vsphere-unverified-ssl
  vsphere-datacenter = var.vsphere-datacenter
  vm-domain = var.vm-domain
  vsphere-template-folder = var.vsphere-template-folder
  vm-template-name = var.vm-template-name
  vm-network = var.vm-network
  vm-guest-id = var.vm-guest-id
  vm-adapter_type = var.vm-adapter_type
  linux_pass = var.linux_pass
}
