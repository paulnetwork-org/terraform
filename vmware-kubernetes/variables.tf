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
