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

# Define VMware vSphere 
data "vsphere_datacenter" "dc" {
  name = var.vsphere-datacenter
}

#data "vsphere_host" "host" {
#  name          = var.esxi-name
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

data "vsphere_datastore" "datastore" {
  name          = var.vm-datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere-cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  count = length(var.vm-names)
  name = var.vm-network[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere-datacenter}/vm/${var.vsphere-template-folder}/${var.vm-template-name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Create VMs
resource "vsphere_virtual_machine" "vm" {
  firmware = "efi"
  count = length(var.vm-names)
  name  = var.vm-names[count.index]
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id  = data.vsphere_datastore.datastore.id

  num_cpus = var.vm-cpu[count.index]
  memory   = var.vm-ram[count.index]
  guest_id = var.vm-guest-id
  

  network_interface {
    network_id = data.vsphere_network.network[count.index].id
    adapter_type = var.vm-adapter_type
  }

  disk {
    label = var.vm-names[count.index]
    thin_provisioned = true
    size  = var.vm_disk_size_gb[count.index]
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.vm-names[count.index]
        domain = var.vm-domain
      }     
      network_interface {
        ipv4_address  = var.vm_ipv4_addresses[count.index]
        ipv4_netmask  = var.vm_ipv4_netmask  
      }
      ipv4_gateway  = var.vm_ipv4_gateways[count.index]
      timeout = 30
    }
  }
}



