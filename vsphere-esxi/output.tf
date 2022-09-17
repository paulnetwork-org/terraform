output "control_ip_addresses" {
 value = vsphere_virtual_machine.control.*.default_ip_address
}
