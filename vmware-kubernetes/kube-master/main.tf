terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.3.1"
    }
  }
}



# Define VMware vSphere 
data "vsphere_datacenter" "dc" {
  name = var.vsphere-datacenter
}

data "vsphere_host" "host" {
  name          = var.esxi
  datacenter_id = data.vsphere_datacenter.dc.id
}



data "vsphere_datastore" "datastore" {
  name          = var.vm-datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

#data "vsphere_compute_cluster" "cluster" {
#  name          = var.vsphere-cluster
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

data "vsphere_network" "network" {
  name = var.vm-network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere-datacenter}/vm/${var.vsphere-template-folder}/${var.vm-template-name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Create VMs
resource "vsphere_virtual_machine" "vm" {
  firmware = "efi"
  name  = var.vm-names
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id  = data.vsphere_datastore.datastore.id

  num_cpus = var.vm-cpu
  memory   = var.vm-ram
  guest_id = var.vm-guest-id
  
  
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = var.vm-adapter_type
  }

  disk {
    label = var.vm-names
    thin_provisioned = true
    size  = var.vm_disk_size_gb
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.vm-names
        domain = var.vm-domain
      }     
      network_interface {
        ipv4_address  = var.vm_ipv4_address
        ipv4_netmask  = var.vm_ipv4_netmask  
      }
      ipv4_gateway  = var.vm_ipv4_gateway
      timeout = 30
    }
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = var.linux_pass
    host     = vsphere_virtual_machine.vm.default_ip_address
  }
    provisioner "remote-exec" {
      inline = [
        "sleep 5",
          "sudo kubeadm init --apiserver-advertise-address=192.168.200.20 --pod-network-cidr=10.244.0.0/16",
        "sleep 1",
          "mkdir -p $HOME/.kube",
          "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
          "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
        "sleep 1",
          "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml"
      ]
    }
    provisioner "local-exec" {
      command = "sshpass -p '${var.linux_pass}' ssh ubuntu@192.168.200.20 'sudo kubeadm token create --print-join-command' > join.txt"
    }
}
