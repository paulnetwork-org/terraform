variable "token" {
    description = "Your API access token"
    type = string
    sensitive = true
}

variable "ssh_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "admin_password" {
    description = "your admin username password"
}

variable "admin_username" {
  default = "ubuntu"
}
