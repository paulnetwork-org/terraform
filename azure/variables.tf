variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "location" {
  default = "westeurope"
}


