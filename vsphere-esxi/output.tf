output "vm_name_to_ipv4_address" {
  value = [
    for i in range(length(var.vm-names)) : {
      name      = var.vm-names[i]
      ipv4_addr = var.vm_ipv4_addresses[i]
    }
  ]
}
