terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "masternode" {
  count     = 1 
  name      = format("kubemaster-%02d", count.index + 1)
  image     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
  cpus      = 2 
  memory    = "2048 mib"
  status    = "running"
  network_adapter {
    type           = "bridged"
    host_interface = "enp3s0"
  }
}

resource "virtualbox_vm" "workernode" {
  count     = 2 
  name      = format("kubeworker-%02d", count.index + 1)
  image     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova" 
  cpus      = 2 
  memory    = "2048 mib"
  network_adapter {
    type           = "bridged"
    host_interface = "enp3s0"
  }
}




