#===========================#
# VMware vCenter connection #
#===========================#

variable "vsphere-user" {
  type        = string
  description = "VMware vSphere user name"
}

variable "vsphere-password" {
  type        = string
  description = "VMware vSphere password"
}

variable "vsphere-vcenter" {
  type        = string
  description = "VMWare vCenter server FQDN / IP"
}

variable "vsphere-unverified-ssl" {
  type        = string
  description = "Is the VMware vCenter using a self signed certificate (true/false)"
  default = "true"
}

variable "vsphere-datacenter" {
  type        = string
  description = "VMWare vSphere datacenter"
}

#variable "vsphere-cluster" {
#  type        = string
#  description = "VMWare vSphere cluster"
#}

variable "vsphere-template-folder" {
  type        = string
  description = "Template folder"
  default = "templates"
}

variable "vm-template-name" {
  type        = string
  description = "The template to clone to create the VM"
  default = "ubuntu22.04-kube-1.26.3-installed"
}


#================================#
# VMware vSphere virtual machine #
#================================#

variable "vm-network" {
  type        = string
  description = "Network used for the vSphere virtual machines"
  default = "PN-test"
}


variable "vm-guest-id" {
  type        = string
  description = "The ID of virtual machines operating system"
  default = "ubuntu64Guest"
}

variable "vm-adapter_type" {
  type        = string
  description = "The Adapter type"
  default = "vmxnet3"
}

variable "vm-domain" {
  type        = string
  description = "Linux virtual machine domain name for the machine. This, along with host_name, make up the FQDN of the virtual machine"
}

variable "linux_pass" {
  type  = string
  description = "Linux username password"
}



# different
# different
# different

variable "esxi" {
  type  = string
  description = "Esxi used"
  default = "esxi.paulnetwork.local"
}

variable "vm-datastore" {
  type        = string
  description = "Datastore used for the vSphere virtual machines"
  default = "DS1-SSD-1TB"
}



variable "vm-names" {
  type        = string
  description = "List of names for the VMs"
  default = "kube-master"
}

variable "vm-cpu" {
  type        = string
  description = "Number of vCPU for the vSphere virtual machines"
  default = "4"
}

variable "vm-ram" {
  type        = string
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default = "4048"
}


variable "vm_disk_size_gb" {
  type = string
  description = "The disk sizes"
  default = "100"
}

variable "vm_ipv4_address" {
  type  = string
  description = "Enter ipv4 addresses for the VM's"
  default = "192.168.200.20"
}

variable "vm_ipv4_netmask" {
  type = string
  description = "Enter class network range ex. /24"
  default = "24"
}

variable "vm_ipv4_gateway" {
  type = string
  description = "Enter the gateway's for every VM"
  default = "192.168.200.1"
}
