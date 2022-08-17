output "kubemasterip1" {
  value = virtualbox_vm.masternode.*.network_adapter.0.ipv4_address
}
output "workerip1" {
  value = element(virtualbox_vm.workernode.*.network_adapter.0.ipv4_address, 1)
}
output "workerip2" {
  value = element(virtualbox_vm.workernode.*.network_adapter.0.ipv4_address, 2)
}
