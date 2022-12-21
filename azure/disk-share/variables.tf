variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

#variable "resource_group_name_prefix" {
#  default     = "paul"
#}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "location" {
  default = "westeurope"
}
