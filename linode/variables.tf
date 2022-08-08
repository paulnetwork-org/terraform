variable "token" {
    description = "Your API access token"
    type = string
    sensitive = true
}

variable "k8s_version" {
    description = "1.23"
}

variable "label" {
    description = "laroa-cluster"
}

variable "region" {
    description = "eu-central"
}

variable "tags" {
    description = "Tags to apply to your cluster"
    type = list(string)
    default = ["website"]
}

variable "pools" {
    description = "laroa"
    type = list(object({
        type = string
        count = number
      }))
    default = [
        {
          type = "g6-standard-4"
          count = 3
        }
      ]
    }

variable "ssh_public_key" {
    default = "/home/node/.ssh/id_rsa.pub"
}

variable "root_password" {
    default = "Terraform123"
}

