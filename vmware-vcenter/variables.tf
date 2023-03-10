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

variable "vsphere-cluster" {
  type        = string
  description = "VMWare vSphere cluster"
}

#variable "esxi-name" {
#  type  = string
#  description = "Esxi used"
#}

variable "vm-datastore" {
  type        = string
  description = "Datastore used for the vSphere virtual machines"
}

variable "vsphere-template-folder" {
  type        = string
  description = "Template folder"
  default = "templates"
}

variable "vm-template-name" {
  type        = string
  description = "The template to clone to create the VM"
  default = "ubuntu22.04-template"
}


#================================#
# VMware vSphere virtual machine #
#================================#

variable "vm-network" {
  type        = list
  description = "Network used for the vSphere virtual machines"
  default = ["PN-test", "PN-Servers", "PN-test"]
}

variable "vm-names" {
  type        = list
  description = "List of names for the VMs"
  default = ["firsttest", "ubuntutest", "whatevertest"]
}

variable "vm-cpu" {
  type        = list
  description = "Number of vCPU for the vSphere virtual machines"
  default = ["2", "4", "6"]
}

variable "vm-ram" {
  type        = list
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default = ["2048", "4096", "8192"]
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

variable "vm_disk_size_gb" {
  type = list
  description = "The disk sizes"
  default = ["50", "80", "100"]
}

variable "vm-domain" {
  type        = string
  description = "Linux virtual machine domain name for the machine. This, along with host_name, make up the FQDN of the virtual machine"
}

variable "vm_ipv4_addresses" {
  type  = list
  description = "Enter ipv4 addresses for the VM's"
  default = ["192.168.200.71", "192.168.200.72", "192.168.200.73"]
}

variable "vm_ipv4_netmask" {
  type = string
  description = "Enter class network range ex. /24"
  default = "24"
}

variable "vm_ipv4_gateways" {
  type = list
  description = "Enter the gateway's for every VM"
  default = ["192.168.200.1", "192.168.200.1", "192.168.200.1"]
}




